FROM golang:1.14.4-alpine3.12

ENV APP_NAME broker

WORKDIR /go/src/${APP_NAME}
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

FROM alpine:latest
WORKDIR /home
# Copy the binary file from the first image
COPY --from=0 /go/bin/gosse .
COPY --from=0 /go/src/broker/index.html .

RUN adduser -D appto
RUN chown -R appto:root /home/gosse

USER appto

CMD ["/home/gosse"]