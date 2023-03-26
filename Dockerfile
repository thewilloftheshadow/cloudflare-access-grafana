FROM --platform=linux/arm64 golang:latest as builder
ARG MOD
ENV MOD ${MOD:-readonly}
RUN mkdir /build
ADD . /build/
WORKDIR /build
RUN echo "go mod flag: $MOD"
RUN CGO_ENABLED=0 GOOS=linux go build -mod=$MOD -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .

FROM --platform=linux/arm64 alpine
WORKDIR /app
COPY --from=builder /build/main /app
EXPOSE 8080
CMD ["./main"]
