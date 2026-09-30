kind: flatpak_repo

build-depends:
- freedesktop-sdk.bst:components/flatpak-minimal-image.bst
- filename: flatpak-repo-deps.bst
  config:
    flatpak-stack: True

config:
  arch: "%{flatpak_arch}"
  repo-mode: bare-user-only
  branch: '%{branch}'
