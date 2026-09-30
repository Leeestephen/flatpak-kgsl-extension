# Building

## Host prerequisites

The currently verified development host is x86-64 Arch Linux. BuildStream
requires Bubblewrap, FUSE3, Git, lzip, patch, Python, and three BuildBox tools.

BuildStream 2.8.1 is installed in an isolated pipx environment. The project
uses `git_repo` and `cargo2` plugins whose runtime imports are not all declared
by the junction package, so the environment also contains:

```sh
pipx inject buildstream dulwich requests tomlkit
pipx inject buildstream 'buildstream-plugins-community==2.3.0'
```

### BuildBox

The official static BuildBox 1.4.25 bundle is installed in `~/.local/bin`:

```text
buildbox-casd
buildbox-fuse
buildbox-run-bubblewrap
buildbox-run -> buildbox-run-bubblewrap
```

Immutable bundle URL:

```text
https://gitlab.com/BuildGrid/buildbox/buildbox-integration/-/releases/1.4.25/downloads/buildbox-x86_64-linux-gnu.tgz
```

Observed SHA-256:

```text
3a55195f04a2ae57b5485d4b85859ab95b724f2f2215ed367295dc25001783f8
```

The host must also expose `/dev/fuse`, provide `fusermount3`, and permit
unprivileged user namespaces.

## Resolve the pipeline

The target is aarch64 even when the bootstrap seed runs on an x86-64 host.
BuildStream's `arch` option defaults to the host and cannot declare a project
default, so direct `bst` invocations must supply both options:

```sh
bst --no-colors \
  -o target_arch aarch64 \
  -o bootstrap_arch x86_64 \
  show flatpak-repo.bst --format '%{name} %{state}'
```

The Makefile supplies these values automatically on the verified host:

```sh
make build
make export-repo REPO=repo
```

Do not publish the resulting OSTree repository before completing
`docs/TESTING.md`.
