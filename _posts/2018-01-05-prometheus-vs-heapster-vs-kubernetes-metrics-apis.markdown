---
layout: post
title: Prometheus vs. Heapster vs. Kubernetes Metrics APIs
archived: false
---

In this blog post, I will try to explain the relation between [Prometheus][prometheus], [Heapster][heapster], as well as the [Kubernetes][kubernetes] metrics APIs and conclude with the recommended way how to autoscale workloads on Kubernetes.

This post assumes you have a basic understanding of [Kubernetes][kubernetes] and monitoring.

## Heapster

Heapster provides metric collection, basic monitoring capabilities and supports multiple data sinks to write the collected metrics to. The code for each sink resides within the Heapster repository. Heapster also enables the use of the [Horizontal Pod Autoscaler][hpa] to autoscale on metrics.

There are two problems with the architecture Heapster has chosen to implement. It assumes that the data store is a bare time-series database and allows a direct write path to it. This makes it fundamentally incompatible with Prometheus, as Prometheus is a pull based model. Because the rest of the Kubernetes ecosystem has first class Prometheus support, these circumstances often cause people to run Prometheus, Heapster, as well as an additional non-Prometheus data store for Heapster, most of the time that is InfluxDB.

Furthermore as the code for each sink resides in Heapster, this results in a "vendor dump". A "vendor dump" is when vendors, which for example provide a SaaS offering for monitoring implement support for their system and then abandon any support for the implementation. This is a common cause of frustration when maintaining Heapster. At the time of writing this article, many of the 15 supported sinks have not been supported for a long time.

Even though Heapster doesn’t implement Prometheus as a data sink, it exposes metrics in Prometheus format. This often causes additional confusion.

A bit over a year ago [sig-instrumentation][sig-instrumentation-mailinglist] was founded and this problem was one of the first we started to tackle. Contributors and maintainers of Heapster, Prometheus and Kubernetes came together and designed the resource and custom metrics APIs.

## Resource and custom metrics APIs

To solve the existing problems with Heapster and not to repeat the mistakes, the resource and custom metrics APIs were defined. Intentionally these are just API definitions and not implementations. They are installed into a Kubernetes cluster as [aggregated APIs][kubernetes-aggregated-api], this allows the implementations to be switched out, but the API stays the same. Both APIs are defined to respond with the current value of the requested metric/query and are both available in beta starting with Kubernetes 1.8.0. Historical metrics APIs may be defined and implemented in the future.

The canonical implementation of the resource metrics API is the [metrics-server][metrics-server-repo]. The metrics-server simply gathers what is referred to as the resource metrics: CPU, memory (and possibly more in the future). It gathers these from all the kubelets in a cluster through the kubelet's stats API. When gathered the metrics-server simply keeps all values on Pods and Nodes in memory.

The custom metrics API, as the name says, allows requesting arbitrary metrics. Custom metrics API implementations are specific to the respective backing monitoring system. Prometheus was the first monitoring system that an adapter was developed for, simply due to it being a very popular choice to monitor Kubernetes. This adapter can be found in the [k8s-prometheus-adapter][k8s-prometheus-adapter-repo] repository on GitHub. Requests to the k8s-prometheus-adapter (aka the Prometheus implementation of the custom-metrics API), are converted to a Prometheus query and executed against the respective Prometheus server. The result Prometheus returns is then returned by the custom metrics API adapter.

This architecture solves all the problems we intended to solve:

* Resource metrics can be used more reliably and consistently.
* There is no "vendor dump" for data sinks. Whoever implements an adapter must maintain it.
* Pull as well as push based monitoring systems can be supported.
* Running Heapster with a datastore like influx in addition to Prometheus will not be necessary anymore.
* Prometheus can consistently be used to monitor, alert and autoscale.

## What to do going forward

With the use of the [k8s-prometheus-adapter][k8s-prometheus-adapter-repo] we can now autoscale on arbitrary metrics that we already collect with Prometheus, without the need to run Heapster at all. In fact, one of the areas sig-instrumentation is currently working on is, phasing out Heapster, meaning it will eventually be unsupported. I recommend switching to using the resource and custom metrics APIs rather sooner than later. To enable using the resource and custom metrics APIs with the HPA one must pass the following flag to the kube-controller-manager:

```
--horizontal-pod-autoscaler-use-rest-clients
```

If I find the time, I may write a more elaborate guide on how to use the custom-metrics API to autoscale in a follow up blog post.

If you are interested in this area and would like to contribute please join us on the sig-instrumentation bi-weekly call on Thursdays at 17:30 UTC. See you there!

If you have any questions feel free to follow up with me on [Twitter](https://twitter.com/fredbrancz) or Kubernetes slack (@brancz). I also want to give [Solly Ross aka DirectXMan12](https://github.com/directXMan12) a huge shout out as he worked on all of this from the HPA to defining the resource and custom metrics APIs as well as implement the k8s-prometheus-adapter.

[prometheus]: https://prometheus.io/
[kubernetes]: https://kubernetes.io/
[heapster]: https://github.com/kubernetes/heapster
[sig-instrumentation-mailinglist]: https://groups.google.com/forum/#!forum/kubernetes-sig-instrumentation
[metrics-server-repo]: https://github.com/kubernetes-incubator/metrics-server
[custom-metrics-api-repo]: https://github.com/kubernetes-incubator/custom-metrics-apiserver
[k8s-prometheus-adapter-repo]: https://github.com/directXMan12/k8s-prometheus-adapter
[hpa]: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
[kubernetes-aggregated-api]: https://kubernetes.io/docs/concepts/api-extension/apiserver-aggregation/
