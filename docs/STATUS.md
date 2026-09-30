# Status

## Bootstrap snapshot

- Repository initialized on 2026-09-30.
- Build structure imported from `freedesktop-sdk/mesa-git-extension` commit
  `d8983e0d9402d80e61fb6e2934d35f42edeadfc8`.
- Extension identity changed to `org.freedesktop.Platform.GL.kgsl`.
- Initial scope restricted to `aarch64`.
- No artifact has been built, installed, or published from this repository.

## Known bootstrap gaps

The imported source pins are deliberately retained for review and are not the
final KGSL configuration:

- `elements/mesa-sources.yml` still points at upstream Mesa rather than a
  pinned lfdevs KGSL revision;
- `elements/freedesktop-sdk.bst` still carries the template's SDK junction pin,
  which must be aligned to Freedesktop `26.08`;
- the inherited Rust dependency cache and libdrm pin must be reconciled with
  the chosen KGSL source;
- local build dependencies and BuildStream cache behavior have not been
  validated;
- no GitHub CI or artifact signing/publishing policy exists yet.

## Milestones

1. Pin the exact lfdevs source revision corresponding to the already tested
   Mesa `26.3.0-devel-20260824` payload, or document a justified newer pin.
2. Align the Freedesktop SDK junction and extension branch to `26.08`.
3. Resolve the source's Meson options and dependency delta without host-library
   injection.
4. Build and inspect the aarch64 extension locally.
5. Install from a local OSTree repository and prove Flatpak Chromium loads only
   extension-provided Mesa libraries.
6. Run the full acceptance and rollback matrix in `docs/TESTING.md`.
7. Add CI only after the local build is reproducible.
