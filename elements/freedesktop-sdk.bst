kind: junction

sources:
- kind: git_repo
  url: fdsdk_git:freedesktop-sdk.git
  track: master
  ref: freedesktop-sdk-25.08rc.3-1697-gba490d00046ddf23d4b13af1eeecf0fde7829f7a
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-kgsl.patch

config:
  options:
    bootstrap_build_arch: "%{bootstrap_arch}"
    target_arch: "%{target_arch}"

  overrides:
    extensions/mesa/libdrm.bst: libdrm.bst
