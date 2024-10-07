FROM golang:1.21.0-alpine as builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -trimpath -ldflags "-w -s" -o app

# ----------------------------

FROM golang:1.21.0-alpine as deploy
RUN apk update

COPY --from=deploy-builder /app/app .

CMD ["../app"]

# ----------------------------

FROM golang:1.21.0-alpine as dev
WORKDIR /app
RUN go install github.com/air-verse/air@latest
CMD ["air"]
