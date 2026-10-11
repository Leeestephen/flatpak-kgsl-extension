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

The `runtime/25.08` branch targets applications using Freedesktop Platform
25.08, including the current VSCodium Flatpak. It inherits the locally accepted
26.08 packaging and KGSL fixes. Its aarch64 build, repository export, ELF
closure, side-by-side installation, and VSCodium hardware-acceleration A/B are
accepted locally on alioth. The repository is not yet published as a signed
Flatpak remote.

See [`docs/STATUS.md`](docs/STATUS.md) for the exact artifact and OSTree keys,
and [`docs/TESTING.md`](docs/TESTING.md) for the retained acceptance contract.

## Scope

- Architecture: `aarch64`
- Runtime target on this branch: Freedesktop Platform `25.08`
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
