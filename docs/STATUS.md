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
- `bootstrap/acl.bst` required a provisional staged-junction change that passes
  `%{build_flags}` through `CFLAGS` and `CXXFLAGS` during its native helper
  configure step. This must become a durable SDK patch after the active build.
- The current build has reached 177 of 209 elements, with 76 built and 33 in
  the remaining build state. It is still running; these figures are a
  checkpoint, not a successful final result.
- No extension artifact has yet been built, installed, or published.

## Known bootstrap gaps

The source/runtime pinning milestone is complete. Remaining build risks are:

- the lfdevs source's Meson/dependency delta must pass inside the Freedesktop
  26.08 BuildStream sandbox;
- the full build must finish and reach the local `libdrm.bst` and `mesa.bst`
  elements without another cross-execution or dependency failure;
- the ACL workaround must be represented by a durable, reviewed SDK patch;
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
