kind: flatpak_image

build-depends:
- mesa.bst

(@):
- freedesktop-sdk.bst:elements/extensions/mesa/config.yml

config:
  include:
  - debug
  directory: "%{debugdir}%{prefix}"
  metadata:
    Runtime:
      name: org.freedesktop.Platform.GL.Debug.kgsl
      runtime: org.freedesktop.Platform/%{flatpak_arch}/%{branch}
      sdk: org.freedesktop.Sdk/%{flatpak_arch}/%{branch}
