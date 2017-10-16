---
layout: post
title: "Kubernetes auth: X509 client certificates"
archived: false
---

Kubernetes supports [multiple means of authentication](https://kubernetes.io/docs/admin/authentication/), for example Static Token File, Static Password File as well as OIDC, which are all very well documented. But another common way of authentication is to make use of [X509 client certificates](https://en.wikipedia.org/wiki/X.509). In this blog post I will explain a bit about X509 client certificates as well as demonstrate how to set them up for use in your Kubernetes cluster.

In contrast to the other authentication methods, using client certificates for authentication uses public key cryptography for authentication instead of passwords or tokens. The advantage of using client certificates for authentication is that there is no provider storing any of this information, it’s pure cryptography, which is why we can trust requests identifying itself with a certificate.

Kubernetes has no user storage itself, therefore the identity must come from the chosen authentication mean. For example if you were to choose [Open ID Connect](https://kubernetes.io/docs/admin/authentication/#openid-connect-tokens), then the OIDC providers stores this information, and on authentication requests returns the respective user, which Kubernetes then uses to perform authorization. X509 client certificates fit that use case perfectly, as the content is signed by the Kubernetes cluster certificate authority and the Kubernetes apiserver only has to verify that the signature is legitimate. This means the user and group specified in the certificate are used once the signature is verified - no storage required.

In the case of X509 client certificates, Kubernetes verifies that the provided client certificate is in fact signed by the cluster's certificate authority. Once Kubernetes has verified the certificate, it will treat the "Common Name" as the username and the "Organization" as the group of the user. Using this information one can then give a group or a user specific permission, using [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/). This is how an example `ClusterRole` manifest, that has read-only permissions for all Pods and Namespaces would look like:

```yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: read-only-user
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - namespaces
  verbs:
  - get
  - list
  - watch
```

Now to give a user these permissions, a `ClusterRoleBinding` has to be created.

```yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: read-only-users
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: read-only-user
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: brancz
```

The above `ClusterRoleBinding` gives the user named "brancz" the roles specified in the `ClusterRole` called "read-only-user".

That was easy enough. I have written a small script to automate the process. The script first generates the client certificates, signs them with the cluster's certificate authority and finally generates a bundled `kubeconfig`. As a result the `kubeconfig` is ready to be used with the Kubernetes cluster. The file is placed in the `clients/$USER/` directory (and creates missing directories as needed).

```bash
#!/usr/bin/env bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 user group"
    exit 1
fi

USER=$1
GROUP=$2
CLUSTERENDPOINT=https://<apiserver-ip>:<apiserver-port>
CLUSTERNAME=your-kubernetes-cluster-name
CACERT=cluster/tls/ca.crt
CAKEY=cluster/tls/ca.key
CLIENTCERTKEY=clients/$USER/$USER.key
CLIENTCERTCSR=clients/$USER/$USER.csr
CLIENTCERTCRT=clients/$USER/$USER.crt

mkdir -p clients/$USER

openssl genrsa -out $CLIENTCERTKEY 4096
openssl req -new -key $CLIENTCERTKEY -out $CLIENTCERTCSR \
      -subj "/O=$GROUP/CN=$USER"
openssl x509 -req -days 365 -sha256 -in $CLIENTCERTCSR -CA $CACERT -CAkey $CAKEY -set_serial 2 -out $CLIENTCERTCRT

cat <<-EOF > clients/$USER/kubeconfig
apiVersion: v1
kind: Config
preferences:
  colors: true
current-context: $CLUSTERNAME
clusters:
- name: $CLUSTERNAME
  cluster:
    server: $CLUSTERENDPOINT
    certificate-authority-data: $(cat $CACERT | base64 --wrap=0)
contexts:
- context:
    cluster: $CLUSTERNAME
    user: $USER
  name: $CLUSTERNAME
users:
- name: $USER
  user:
    client-certificate-data: $(cat $CLIENTCERTCRT | base64 --wrap=0)
    client-key-data: $(cat $CLIENTCERTKEY | base64 --wrap=0)
EOF
```

> Note: This script was written to be run on Fedora 26, there may be slight incompatibilities across distributions. Make sure to adapt the paths to your certificate authority if they are different. The content of this blog post works on Kubernetes 1.7.x+.

Thanks for reading, for any questions and feedback feel free to contact me on [twitter](https://twitter.com/fredbrancz).
