# Architecture

## Ownership boundary

This repository owns the Flatpak packaging layer:

- `org.freedesktop.Platform.GL.kgsl` metadata and filesystem layout;
- branch matching against supported Freedesktop Platform releases;
- reproducible source pins and build configuration;
- local OSTree repository export, installation, rollback, and validation;
- CI for the supported `aarch64` artifact.

It consumes, but does not own, the KGSL Mesa implementation from
`lfdevs/mesa-for-android-container`. Anland and Droidspaces should only expose
the required device and document or select the extension. Kernel UAPI work
belongs in the kernel/backport project.

## Runtime selection

Flatpak mounts GL extensions below the platform's GL extension point. A client
selects this build by placing `kgsl` in `FLATPAK_GL_DRIVERS`:

```sh
FLATPAK_GL_DRIVERS=kgsl flatpak run APP_ID
```

The extension branch must exactly match the application's Freedesktop runtime
branch. The first target is `aarch64/26.08`, matching the installed Ungoogled
Chromium runtime.

## Build lineage

The repository starts from the BuildStream structure used by
freedesktop-sdk's `mesa-git-extension`. That supplies the platform junction,
Mesa dependency graph, Flatpak image layout, debug split, metainfo generation,
and OSTree export path.

The important KGSL-specific changes are:

1. use a pinned lfdevs source revision that contains the Android/KGSL work;
2. compile only the relevant aarch64 Freedreno/Turnip drivers and required
   software fallbacks;
3. install below the `GL/kgsl` extension prefix;
4. publish `org.freedesktop.Platform.GL.kgsl` for the matching runtime branch;
5. validate access to `/dev/kgsl-3d0` separately from driver packaging.

Host distribution libraries must not be injected with `LD_LIBRARY_PATH` in the
finished design. Every shipped library must be built against, or deliberately
provided for, the matching Freedesktop runtime ABI.
