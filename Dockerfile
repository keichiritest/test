FROM golang:latest AS builder

WORKDIR /app/

RUN go get \
  golang.org/x/lint/golint \
  github.com/alecthomas/gometalinter \
  github.com/ethereum/go-ethereum \
  github.com/aws/aws-sdk-go \
  github.com/stretchr/testify

RUN gometalinter --install

ADD *.go /app/
ADD .gometalinter.json /app/

RUN gometalinter
RUN go test
RUN go build -ldflags "-linkmode external -extldflags -static" -a -o main .

FROM alpine:latest
RUN apk --no-cache add ca-certificates bash
WORKDIR /app/

COPY --from=builder /app/main .
ADD entrypoint.sh /app/

CMD ["/app/entrypoint.sh"]
