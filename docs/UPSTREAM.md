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
- License and source revision: to be recorded when the source pin is selected

Do not replace the source URL without recording the exact commit, license,
patch relationship, and corresponding tested binary version here.
