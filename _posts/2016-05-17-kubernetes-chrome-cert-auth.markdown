---
layout: post
title: Kubernetes OSX Chrome Client Cert Auth
teaser: 
commets: true
---

So you have just set up your Kubernetes cluster using the excellent [`kube-aws`
tool provided by CoreOS](https://github.com/coreos/coreos-kubernetes/releases).
It created a bunch of certificates and one of them being the certificate used
to authenticate against the Kubernetes `apiserver` when using `kubectl`.

When we look into our `kubeconfig` file we see that that is the
`credentials/admin-key.pem` and `credentials/admin.pem`.

	client-certificate: credentials/admin.pem                                                                                                                                        
	client-key: credentials/admin-key.pem   

Unfortunately the OSX client certificate store and chrome do not like
certificates in pem format, but need to be in `.pfx`.

We unpack the `openssl` magic tool and it can of course convert that for us.

	$ openssl pkcs12 -inkey credentials/admin-key.pem -in credentials/admin.pem -export -out admin.pfx

Now we can import that resulted `admin.pfx` certificate and we can easily look
at kubedash, kubernetes dashboard, or do api requests within chrome.

