FROM golang:1.9.2-alpine3.6

RUN apk add --update git make \
  && git clone https://github.com/google/mtail /go/src/github.com/google/mtail \
  && cd /go/src/github.com/google/mtail \
  && make \
  && rm -rf /tmp/* /var/cache/apk/*

FROM alpine:3.6

RUN adduser -D -h /mtail -u 1000 mtail \
  && chown mtail:mtail /mtail && chmod 755 /mtail
USER mtail
COPY --from=0 /go/bin/mtail /usr/local/bin/mtail
COPY mtail/progs /mtail/progs
ENTRYPOINT ["/usr/local/bin/mtail"]
