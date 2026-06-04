FROM golang:1.26-alpine AS backend-builder

WORKDIR /src

ENV GOPROXY=https://goproxy.cn,direct \
    GOSUMDB=sum.golang.google.cn \
    GO111MODULE=on

RUN --mount=type=cache,id=alpine-apk-cache,target=/var/cache/apk \
    sed -i 's#dl-cdn.alpinelinux.org#mirrors.aliyun.com#g' /etc/apk/repositories \
    && apk add --no-cache ca-certificates git build-base

COPY ./go.mod ./

# 使用 go mod download 和 build 的缓存挂载
RUN --mount=type=cache,id=go-mod-cache,target=/go/pkg/mod \
    --mount=type=cache,id=go-build-cache,target=/root/.cache/go-build \
    go mod download

COPY ./ /src

# 编译阶段也使用缓存
RUN --mount=type=cache,id=go-mod-cache,target=/go/pkg/mod \
    --mount=type=cache,id=go-build-cache,target=/root/.cache/go-build \
    go build -ldflags="-s -w" -o /out/coinmarket .


FROM alpine:3.20

WORKDIR /app

# apk 安装也使用缓存
RUN --mount=type=cache,id=alpine-apk-cache,target=/var/cache/apk \
    sed -i 's#dl-cdn.alpinelinux.org#mirrors.aliyun.com#g' /etc/apk/repositories \
    && apk add --no-cache ca-certificates tzdata \
    && addgroup -S app && adduser -S app -G app

COPY --from=backend-builder /out/coinmarket /app/coinmarket

RUN chown -R app:app /app
USER app

ENV TZ=Asia/Shanghai \
    GIN_MODE=release

EXPOSE 18000

CMD ["/app/coinmarket"]
