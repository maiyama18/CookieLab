# CookieLab

A mobile application experiment for session management validation using HTTP Cookies.

## How it works

### Endpoints

- POST `/login`
- POST `/logout`
- GET `/message`

### Flow

`/message` requires authorization. So `/message` should be called after getting valid cookie by calling `/login`.

![CleanShot 2025-02-08 at 12 50 50](https://github.com/user-attachments/assets/108fac07-f2fa-4be9-8798-0ef47ad3def1)

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

