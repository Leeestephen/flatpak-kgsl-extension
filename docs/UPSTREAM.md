# Upstream provenance

The initial BuildStream and Flatpak-extension layout was adapted from:

- Project: `freedesktop-sdk/mesa-git-extension`
- URL: <https://gitlab.com/freedesktop-sdk/mesa-git-extension>
- Imported commit: `d8983e0d9402d80e61fb6e2934d35f42edeadfc8`
- Import date: 2026-09-30
- License: MIT

The upstream `LICENSE` file is retained at the repository root. Files are being
modified to publish an aarch64 KGSL-specific extension rather than the upstream
multi-architecture Mesa development snapshot.

The intended Mesa implementation source is:

- Project: `lfdevs/mesa-for-android-container`
- URL: <https://github.com/lfdevs/mesa-for-android-container>
- Source tag: `mesa-26.3.0-devel-20260824`
- Source commit: `98f3d6229d61452cef80f8563af7c56ae599dc14`
- Source version observed at runtime: `26.3.0-devel (git-98f3d6229d)`
- License: Mesa's per-file SPDX licensing, predominantly MIT; the complete
  source `licenses/` directory is copied into the extension

The matching platform junction is Freedesktop SDK tag
`freedesktop-sdk-26.08.2`, peeled commit
`32c5fea70e827885fc805d38a9dc5716c39ed173`.

Do not replace either pin without recording the exact commit, license, patch
relationship, runtime branch, and corresponding tested binary version here.
