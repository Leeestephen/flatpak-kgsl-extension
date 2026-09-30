# Testing

No bootstrap artifact is considered usable until every identity, isolation,
graphics, and rollback check below passes.

## Build checks

- Build `ARCH=aarch64` against the intended Freedesktop `26.08` branch.
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
