# Testing

No bootstrap artifact is considered usable until every identity, isolation,
graphics, and rollback check below passes.

## Build checks

- Build `ARCH=aarch64` against the intended Freedesktop `25.08` branch.
- Validate that the repository contains only
  `org.freedesktop.Platform.GL.kgsl` and its matching debug ref.
- Inventory ELF dependencies and reject unresolved or host-only libraries.
- Confirm the runtime files are mounted under the platform's `GL/kgsl` path.

## Sandbox checks

- Confirm the application has the intended `/dev/kgsl-3d0` permission.
- Confirm no host Mesa directory or broad host filesystem override is present.
- Capture `/proc/<gpu-pid>/maps` and prove EGL, GBM, Gallium, and Vulkan files
  come from the Flatpak runtime/extension.
- Verify `FLATPAK_GL_DRIVERS=kgsl` selects the extension and that removing the
  selector returns to the stock runtime driver.

## Graphics acceptance

- EGL probe: GBM, Wayland, X11, surfaceless, and device platforms as applicable.
- OpenGL: renderer `FD650`, vendor `freedreno`, hardware acceleration enabled.
- Vulkan: Turnip Adreno 650 visible through `vulkaninfo --summary`.
- Ungoogled Chromium: hardware Canvas, compositing, rasterization, OpenGL,
  WebGL, and WebGPU, without GPU-blocklist bypass flags.
- VSCodium on 25.08: Electron's GPU process must omit `--use-gl=disabled`, map
  Mesa/LLVM from `GL/kgsl`, open `/dev/kgsl-3d0`, allocate dma-bufs, and render
  the complete window. The selector-free control must return to `GL/default`
  and software compositing.
- LibreWolf is a secondary compatibility check because its own platform policy
  may independently block acceleration.
- Recheck Anland 200% scaled rendering and ensure the extension does not hide
  compositor/protocol defects.

## Stability and rollback

- Cold container restart and repeated application launches.
- Suspend/resume, Android home/recents, rotation, and multi-window transitions.
- Video playback and ordinary browsing workload.
- Uninstall the extension or remove `kgsl` from `FLATPAK_GL_DRIVERS`; confirm
  applications return cleanly to the stock runtime without deleting profiles.

## Accepted 25.08 result

The 2026-10-11 alioth run passed the build, repository, dependency, sandbox,
graphics-provenance, and selector-rollback checks for VSCodium 1.135.06055.
The installed release commit is
`34d71b085b2d634f643b1075f0a67e0c9ff0c238bed125bfc8aa854ff39cb9db`.
The long-duration lifecycle matrix above remains a regression contract for
future replacement builds rather than a claim that every item was repeated in
that bounded acceptance run.
