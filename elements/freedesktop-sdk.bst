kind: junction

sources:
- kind: git_repo
  url: fdsdk_git:freedesktop-sdk.git
  track: freedesktop-sdk-26.08.*
  ref: freedesktop-sdk-26.08.2-0-g32c5fea70e827885fc805d38a9dc5716c39ed173
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-kgsl.patch

config:
  options:
    bootstrap_build_arch: "%{bootstrap_arch}"
    target_arch: "%{target_arch}"

  overrides:
    extensions/mesa/libdrm.bst: libdrm.bst
