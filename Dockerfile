# Build Geth in a stock Go builder container
FROM golang:alpine as builder

RUN apk add --no-cache wget curl make gcc musl-dev linux-headers

RUN wget -P /go-ethereum https://github.com/$(curl -s -L https://github.com/ethereum/go-ethereum/releases/latest | egrep -o 'ethereum/go-ethereum/archive/(.*).tar.gz')
RUN cd /go-ethereum \
    && tar -zxvf $(ls | egrep -o '(.*)tar.gz') \
    && cd $(ls | egrep -o 'go-ethereum-(.*)') \
    && make geth \
    && cp ./build/bin/geth /usr/local/bin/ \
    && chmod +x /usr/local/bin/geth

RUN rm -rf /go-ethereum

WORKDIR /

ENTRYPOINT [ "geth" ]