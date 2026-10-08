kind: junction

sources:
- kind: git_repo
  url: fdsdk_git:freedesktop-sdk.git
  track: freedesktop-sdk-25.08.*
  ref: freedesktop-sdk-25.08.17-0-g4535d0fa4894628fdf49999ac5c2aacd138a6035
- kind: patch
  path: patches/freedesktop-sdk/acl-cross-build-flags.patch

config:
  options:
    bootstrap_build_arch: "%{bootstrap_arch}"
    target_arch: "%{target_arch}"

  overrides:
    extensions/mesa/libdrm.bst: libdrm.bst
