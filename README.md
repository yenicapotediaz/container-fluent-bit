# container-fluent-bit
[Fluent Bit](http://fluentbit.io/) is an open source and multi-platform Log Forwarder which allows you to collect data/logs from different sources, unify and send them to multiple destinations. 

The `container-fluent-bit` repo contains a Dockerfile (and Jenkinsfile) to build (and test) the `quay.io/samsung_cnct/fluent-bit` container. This container is used by [chart-fluent-bit](https://github.com/samsung-cnct/chart-fluent-bit), among others. See the chart repo for information on installing and configuring Fluent Bit on Kubernetes.
