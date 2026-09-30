# Flatpak KGSL extension

Experimental Flatpak GL-driver extension for Mesa's Freedreno/Turnip KGSL
backend on Android-hosted Linux containers.

The intended runtime ID is:

```text
org.freedesktop.Platform.GL.kgsl
```

Applications select it with:

```sh
FLATPAK_GL_DRIVERS=kgsl flatpak run APP_ID
```

## Status

This repository is in its bootstrap phase and does **not** yet produce a
validated KGSL runtime. Its build layout was adapted from freedesktop-sdk's
`mesa-git-extension`; the tested lfdevs Mesa revision and Freedesktop 26.08.2
SDK are now pinned, but the first sandboxed extension build is still pending.

Do not publish or install artifacts until the milestones in
[`docs/STATUS.md`](docs/STATUS.md) have passed.

## Scope

- Architecture: `aarch64`
- Initial runtime target: Freedesktop Platform `26.08`
- Driver selector: `kgsl`
- Initial hardware validation: Qualcomm Adreno 650 through `/dev/kgsl-3d0`
- Mesa source family: `lfdevs/mesa-for-android-container`

The project packages the userspace GL/Vulkan driver extension. It does not own
Mesa's KGSL implementation, Android kernel support, Anland, Droidspaces, or
Flatpak itself.

## Documentation

- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — ownership and runtime design
- [`docs/STATUS.md`](docs/STATUS.md) — current state and next milestones
- [`docs/BUILDING.md`](docs/BUILDING.md) — host setup and build commands
- [`docs/TESTING.md`](docs/TESTING.md) — build and acceptance matrix
- [`docs/UPSTREAM.md`](docs/UPSTREAM.md) — imported template provenance

## License

The imported build definitions are MIT-licensed. See [`LICENSE`](LICENSE) and
[`docs/UPSTREAM.md`](docs/UPSTREAM.md).
