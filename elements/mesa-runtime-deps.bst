# SPDX-FileCopyrightText: Flatpak KGSL extension contributors
# SPDX-License-Identifier: MIT

kind: manual

(@):
- elements/config.yml

build-depends:
- freedesktop-sdk.bst:extensions/mesa/llvm.bst
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst

config:
  # The SDK LLVM helper already stripped this runtime library. Avoid inheriting
  # the project's image-strip phase for this small relocation element.
  strip-commands: []
  install-commands:
  - |
    source_dir="/usr/lib/%{gcc_triplet}/GL/default/lib"
    found=false
    for source in "$source_dir"/libLLVM.so.*; do
      if [ -f "$source" ]; then
        install -Dm644 "$source" \
          "%{install-root}%{libdir}/$(basename "$source")"
        found=true
      fi
    done
    "$found"
