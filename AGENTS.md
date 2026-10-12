# Repository Guidelines

## Project Structure & Module Organization

This repository is a Rust 2024 Cargo workspace with four crates:

- `lib/` contains shared configuration, database, metadata, playlist, podcast, and protocol code; protobuf sources live in `lib/proto/`.
- `playback/` implements playlist management and audio backends (`rusty`, MPV, and GStreamer).
- `server/` provides the `termusic-server` daemon and its TCP/Unix socket services.
- `tui/` contains the `termusic` terminal UI, CLI, and interactive components.

Most tests are colocated in Rust modules under `#[cfg(test)]`. The Criterion benchmark is in `playback/benches/`; screenshots and other project assets are under `screenshots/` and `assets/`.

## Build, Test, and Development Commands

- `make run` runs the terminal application in development mode.
- `make release` builds all workspace crates in release mode with default features.
- `make test` runs the workspace test suite with coverage and all backend features.
- `make all-backends-test` checks every backend-feature combination without release optimization.
- `make mpv`, `make gst`, or `make rusty` builds a release binary with the selected backend.
- `cargo fmt --all --check` verifies formatting; `cargo clippy --all-targets --all-features -- -D warnings` matches CI linting.

Install the system dependencies listed in `README.md` before enabling MPV, GStreamer, image-cover, or other optional features.

## Coding Style & Naming Conventions

Use four spaces, LF line endings, and a final newline as defined in `.editorconfig`. Run rustfmt before committing. Follow Rust naming conventions: `snake_case` for modules, functions, and variables; `PascalCase` for types; and `SCREAMING_SNAKE_CASE` for constants. Keep unsafe code out of the workspace and resolve Clippy warnings.

## Testing Guidelines

Add focused unit tests beside the implementation they cover and name them for observable behavior (for example, `sorts_by_title`). Run `cargo test --workspace --features cover,all-backends`; run `cargo bench -p termusic-playback --bench async_ring` for benchmark changes.

## Commit & Pull Request Guidelines

Use Conventional Commits with a meaningful type and scope, such as `fix(playback::rusty): ...` or `feat(tui): ...`. Keep commits small and single-purpose. Pull requests should target `master`, explain user-visible changes, link relevant issues, pass formatting, Clippy, tests, and all CI checks, and include screenshots when changing the TUI.
