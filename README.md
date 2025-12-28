# AmongUS — Flutter Game Companion

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Node.js](https://img.shields.io/badge/Node.js-Express-339933?logo=node.js&logoColor=white)](https://expressjs.com)

A clean, feature-first Flutter application inspired by the **Among Us** universe, paired with a lightweight **Node/Express** server used to simulate game-room networking.

> Goal: demonstrate solid Flutter project structure, local persistence, and simple client/server interaction.

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Run the Backend (Node Server)](#run-the-backend-node-server)
- [API Reference (Backend)](#api-reference-backend)
- [Assets & Branding](#assets--branding)
- [Contributing](#contributing)
- [License](#license)
- [👤 Contact](#-contact)

---

## Overview

This repository contains:

- A **Flutter** mobile app (feature-based structure under `lib/features/`)
- A simple **Express** backend (`AmongUS_Server/`) providing endpoints for room data and player registration
- **Local persistence** via **Hive** for client-side storage

---

## Key Features

- **Feature-first organization** for scalable development
- **Room & players flow** backed by an Express server (mock auth token)
- **Local storage** with Hive (`suspects` box)
- **Splash screen & app branding** configured via `flutter_native_splash` and `flutter_launcher_icons`

---

## Tech Stack

**Mobile (Flutter)**

- Flutter / Dart
- `provider` for state management
- `http` for networking
- `hive` + `hive_flutter` for lightweight local persistence

**Backend (Node.js)**

- Node.js
- Express
- In-memory “token” auth (mock access token)

---

## Architecture

The Flutter app is structured to keep responsibilities clear and avoid tight coupling:

- **`lib/app/`**: application bootstrapping (`MaterialApp`, routes entry, app-level concerns)
- **`lib/features/`**: feature modules (screens, controllers/view-models, widgets scoped to the feature)
- **`lib/core/`**: cross-cutting utilities such as networking/storage abstractions

### Design Principles

- **Feature ownership**: UI + logic stays close to its feature to reduce churn.
- **Separation of concerns**: networking/storage live in `core/`, UI stays in `features/`.
- **Predictable state flow**: prefer a single direction for data flow (fetch → state → UI).

---

## Project Structure

High-level layout (trimmed):

```text
amongus/
	lib/
		main.dart
		app/
			app.dart
			assets.dart
		core/
			network/
			storage/
		features/
			splash/
			home/
			game_room/
			player_details/
			emergency_meeting/
	assets/
	test/

AmongUS_Server/
	server.js
	package.json
```

---

## Getting Started

### Prerequisites

- Flutter SDK installed (and a configured emulator/device)
- Dart SDK (comes with Flutter)
- Node.js (for the backend server)

### Install Dependencies (Flutter)

From the Flutter project root:

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

> Notes
>
>- On first launch, the app initializes Hive and opens the `suspects` box.
>- If your screens depend on the backend, start the Node server as well.

---

## Run the Backend (Node Server)

From the backend folder:

```bash
cd ../AmongUS_Server
npm install
npm start
```

By default, the server runs on:

- `http://localhost:3000`

If you run on a physical device, you may need to replace `localhost` in your Flutter networking code with your machine’s LAN IP.

---

## API Reference (Backend)

Base URL: `http://localhost:3000`

### `POST /addplayer`

Registers a player and returns a mock access token.

**Body**

```json
{
	"avatar": "red",
	"username": "Player1"
}
```

**Response**

```json
{
	"access_token": "<token>"
}
```

### `GET /room` (Protected)

Returns the current room snapshot.

**Headers**

- `Authorization: <token>`

**Response**

```json
{
	"name": "Battle Royal",
	"players": [
		{ "avatar": "red", "username": "Hu5tler", "votes": 10 }
	]
}
```

---

## Assets & Branding

Assets are managed in `assets/` and referenced in [pubspec.yaml](pubspec.yaml).

- Splash setup: `flutter_native_splash`
- App icons: `flutter_launcher_icons`

If you update assets, re-generate splash/icons with:

```bash
dart run flutter_native_splash:create
dart run flutter_launcher_icons
```

---

## Contributing

Contributions are welcome.

- Create a feature branch
- Keep changes focused and consistent with the existing structure
- Prefer small PRs with clear intent

---

## License

This project is provided for educational purposes. If you intend to publish or distribute it, add a proper license file.

---

## 👤 Contact

For questions, suggestions, or collaboration opportunities, feel free to reach out:

- **Email**: [feki.karim28@gmail.com](mailto:feki.karim28@gmail.com)
- **LinkedIn**: [Karim Feki](https://www.linkedin.com/in/karimfeki)
- **GitHub**: [Karim Feki](https://github.com/fekikarim)

---

### Final Note

Build it clean, ship it often, and keep iterating — **great software is a habit, not a coincidence.**
