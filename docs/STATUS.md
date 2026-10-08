# Status

## Bootstrap snapshot

- Repository initialized on 2026-09-30.
- Build structure imported from `freedesktop-sdk/mesa-git-extension` commit
  `d8983e0d9402d80e61fb6e2934d35f42edeadfc8`.
- Extension identity changed to `org.freedesktop.Platform.GL.kgsl`.
- Initial scope restricted to `aarch64`.
- BuildStream 2.8.1 and BuildBox 1.4.25 are operational on the x86-64 Arch
  development host. Full project resolution passes with an aarch64 target and
  x86_64 bootstrap seed.
- Mesa is pinned to the tested lfdevs release commit
  `98f3d6229d61452cef80f8563af7c56ae599dc14`
  (`mesa-26.3.0-devel-20260824`).
- The SDK junction is pinned to Freedesktop SDK 26.08.2 commit
  `32c5fea70e827885fc805d38a9dc5716c39ed173`; its exported Flatpak branch is
  `26.08`.
- Targeted source fetches for `mesa.bst` and `libdrm.bst` pass with these pins.
- The KGSL install prefix is defined by local `elements/config.yml`; the SDK
  junction is unmodified so official Freedesktop artifact cache keys remain
  reusable.
- The first sandboxed aarch64 build has validated BuildBox/FUSE/Bubblewrap and
  completed and cached the x86_64 seed, cross-GCC stages 1 and 2, aarch64
  glibc, libxcrypt, and related bootstrap artifacts. It was intentionally
  paused before reaching local `libdrm.bst` and `mesa.bst`; interrupted jobs
  exited with signal status 130, while the BuildStream summary reported zero
  genuine fetch or build failures.
- The resumed full build exposed an execution boundary at `utf-locale.bst`:
  cross-compilation succeeded, but BuildBox initially advertised only x86
  ISAs. QEMU static binfmt plus an ARM64 `arch-test` probe now make
  `buildbox-run --capabilities` advertise `platform:ISA=aarch64`, and the build
  proceeds through aarch64 SDK execution.
- `bootstrap/acl.bst` required passing `%{build_flags}` through `CFLAGS` and
  `CXXFLAGS` during its native helper configure step. The repository now
  carries that change as
  `patches/freedesktop-sdk/acl-cross-build-flags.patch`, applied to the SDK
  junction by `elements/freedesktop-sdk.bst`. The complete-extension rebuild
  successfully staged and used the patched junction.
- The resumed cross-aarch64 build completed all 1,661 Mesa build steps and
  cached `mesa.bst` successfully. Its full artifact ref is
  `flatpak-kgsl-extension/mesa/8432630d3c329061dc57ad509f63bb12f0e7843fe3e826561353e0ff5e699074`.
  A checkout is retained at `/tmp/mesa-exact-artifact-8432630d` for inspection.
- An Anland SurfaceControl investigation found that Freedreno's common BO
  cache rounds `FD_BO_SHARED` allocations to cache-bucket sizes even though
  shared BOs are never returned to that cache. On alioth this changes an
  exported buffer from its descriptor-exact size to whole-MiB bucket sizes,
  which the QTI mapper rejects. A local Mesa patch now bypasses bucket
  selection for shared BOs while retaining page alignment. Its source staging
  was validated successfully with BuildStream and compiled in both the
  extension build and a Debian-native pilot.
- The first Mesa packaging pass exposed an upstream extension assumption that
  `%{sysconfdir}/OpenCL` always exists. Rusticl is disabled for this KGSL
  build, so both the OpenCL move and the corresponding extension-prefix
  symlink in `elements/mesa.yml` are now conditional on the directory being
  present. The active BuildStream transaction captured its element commands
  before this edit. To preserve its long in-flight compilation, an empty
  `buildstream-install/etc/OpenCL` was created inside that single live sandbox;
  this satisfies its already-captured legacy `mv` without changing the output.
  The YAML guard remains the durable fix for every subsequent build.
- The durable rebuild completed and cached patched `mesa.bst` as
  `flatpak-kgsl-extension/mesa/47ece862f8b8c13130d7ca8f8b5cf35bbaaea24e3ec95efbca56e372dce62599`.
  It passed the conditional no-OpenCL packaging path without the earlier
  live-sandbox compatibility directory.
- The live acceptance target is the system-installed Ungoogled Chromium
  `aarch64/stable`, version `152.0.7977.82-1`, on
  `org.freedesktop.Platform/aarch64/26.08`. This exactly matches the extension
  branch and architecture. No KGSL GL extension was installed at the recorded
  pre-test baseline.
- The first complete-repository transaction cached patched Mesa and all heavy
  SDK dependencies, then exposed a missing direct tool dependency in
  `mesa-metainfo.bst`: its install script could not start because the staged
  environment did not provide `sh`. `elements/mesa-metainfo.yml` now declares
  cached bootstrap Bash and Coreutils explicitly for the shell, `mkdir`, and
  `date` commands used by that script. The retry can reuse the completed
  artifacts.
- With those tools present, the inherited mesa-git metadata command exposed a
  second source-shape assumption: `git describe --match '*branchpoint*'`
  cannot describe the pinned lfdevs checkout because BuildStream stages no
  matching tag. Metadata generation now uses `git describe --tags --always`
  and the `HEAD` commit timestamp, producing deterministic metadata even when
  tags are absent.
- AppStream validation then identified the mixed-case developer ID as invalid.
  The template now uses the lowercase reverse-DNS ID
  `io.github.leeestephen`; the remaining runtime-license reference diagnostic
  is informational.
- The complete top-level artifact is cached as
  `flatpak-kgsl-extension/flatpak-repo/9a2c1ac06c5179ab3e13761a10d53f5c20141c7c4c3e3e9521f12def83e98b5c`.
  Its portable archive repository is 99 MiB, passes OSTree fsck across all
  2,721 objects, and contains exactly the release and debug
  `aarch64/26.08` refs. The release commit is
  `20c725c5ca834e5514c52b2b0a3e112f681622f5ba1d959dd476de38e7b2758a`.
- The archive repository is staged in Debian under
  `/home/ste/.local/share/flatpak-kgsl/repo`, registered as the unsigned local
  system remote `kgsl-local`, and the release extension is installed. No broad
  Chromium filesystem override was added. With
  `FLATPAK_GL_DRIVERS=kgsl`, Flatpak resolves the driver set to `kgsl`.
- ADB/nsenter-launched sandbox probes currently fail before application start
  because Bubblewrap attempts to open `/proc/sys/user/max_user_namespaces` for
  writing while that procfs is read-only. This is specific to the diagnostic
  launch context and leaves normal Anland-shell application validation and
  loaded-library provenance outstanding.
- Live application inspection after restoring the accepted Droidspaces procfs
  fix found that the first KGSL image omitted `libLLVM.so.22.1`. Mesa's
  Gallium library links that SONAME, but the Freedesktop LLVM helper installs
  it under `GL/default` while the KGSL image exports only `GL/kgsl`. A direct
  one-library control made EGL report freedreno/FD650 and made Chromium open
  `/dev/kgsl-3d0` with GPU compositing. `mesa-runtime-deps.bst` now relocates
  the cached LLVM runtime library into the KGSL prefix without rebuilding
  Mesa. The corrected repository completed with top-level BuildStream key
  `db9bfc9fb652e382ae1fca084397fa824a1e85ccbdf8be38b453ff42db200be2`;
  its release ref is
  `0195e440a6f3925de11d5ea37971363f0ff59ec821bfa2ed7c3e09bae8ddf0cc`.
  That ref is installed on alioth, and a normal Chromium profile mounts the
  KGSL extension, loads its LLVM/EGL/Gallium stack, opens `/dev/kgsl-3d0`, and
  allocates dma-bufs without the previous software-compositing fallback flags.
  Manual acceptance is complete: `chrome://gpu` reports hardware-accelerated
  compositing, and normal browsing plus YouTube playback passed without the
  earlier visual corruption. The extension is accepted locally on alioth.
- The Flatpak artifact links against the 26.08 SDK's glibc 2.43 and LLVM 22.1,
  so it was not copied into Debian 13. The same patched source was rebuilt
  natively with only Gallium freedreno/KGSL enabled. That candidate passed
  `eglinfo` with FD650 and is installed as the bounded device pilot; its
  SHA-256 is
  `09fb1af3ed1acdd80d32d25d8e3c2a94320c70e70bf6ae14ea30b94e5b80788c`.
- A fresh LibreWolf hardware-WebRender surface exported an exact
  `1600x1200`, 6400-byte-stride, 7,680,000-byte fd. Anland's alioth-calibrated
  QTI import accepted it and selected SurfaceControl `SCANOUT`, proving the
  patch's intended exact-layout interoperability. The stable backend was
  restored to EGL afterward because separate padded-layout and lifecycle
  issues remain in Anland's SC path.

## Known bootstrap gaps

The source/runtime pinning milestone is complete. Remaining build risks are:

- the local durable ACL patch still needs an upstream disposition;
- the cross-aarch64 build has substantial cache/storage cost; final usage and
  reproducible cleanup guidance are not yet known;
- no GitHub CI or artifact signing/publishing policy exists yet.

## Milestones

1. Resolve the source's Meson options and dependency delta without host-library
   injection.
2. Build and inspect the aarch64 extension locally.
3. Install from a local OSTree repository and prove Flatpak Chromium loads only
   extension-provided Mesa libraries.
4. Run the full acceptance and rollback matrix in `docs/TESTING.md`.
5. Add CI only after the local build is reproducible.
