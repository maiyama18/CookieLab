# CookieLab

A mobile application experiment for session management validation using HTTP Cookies.

## How it works

### Endpoints

- POST `/login`
- POST `/logout`
- GET `/message`

### Flow

`/message` requires authorization. So `/message` should be called after getting valid cookie by calling `/login`.

## Setup

### Server

```sh
cd CookieLabServer
go mod tidy
go run .
```

### App

```sh
flutter pub get
flutter run
```

