# Building

## Host prerequisites

The current development host is x86-64 Arch Linux. It is verified for project
resolution, BuildBox sandboxing, and the cross-aarch64 bootstrap. A complete
local aarch64 Mesa build is still in progress. BuildStream requires
Bubblewrap, FUSE3, Git, lzip, patch, Python, and three BuildBox tools.

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

### Executing aarch64 build tools on x86-64

Some Freedesktop SDK elements cross-compile code and then execute an aarch64
program inside the SDK sandbox. Registering QEMU binfmt alone is not enough:
BuildStream rejects the job unless BuildBox advertises aarch64 as a locally
supported ISA.

The verified host setup contains Arch's `qemu-user-static` and
`qemu-user-static-binfmt` packages. Its registration reports:

```text
/proc/sys/fs/binfmt_misc/qemu-aarch64
enabled
interpreter /usr/bin/qemu-aarch64-static
flags: PF
```

BuildBox's capability probe also requires an ARM64 probe from
[`arch-test`](https://github.com/kilobyte/arch-test). The locally built files
are kept at:

```text
/usr/local/bin/arch-test
/usr/local/bin/arch-test-arm64
/usr/local/lib/arch-test/arch-test-arm64
```

Validate the complete setup before building:

```sh
cat /proc/sys/fs/binfmt_misc/qemu-aarch64
buildbox-run --capabilities
```

The latter must include:

```text
platform:ISA=aarch64
platform:ISA=x86-64
```

Without the aarch64 capability, BuildStream fails before binfmt/QEMU can be
used, with `ISA 'aarch64' is not supported by buildbox-run`.

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

The Makefile supplies the architecture values, but its convenience targets do
not yet include the remote-cache bypass or retry options used by the current
cross build:

```sh
make build
make export-repo REPO=repo
```

For the initial local build, the Freedesktop project cache was dominated by
slow negative lookups for this cross-aarch64 configuration. Bypassing both
project remotes made source acquisition substantially faster:

```sh
bst --no-colors \
  -o target_arch aarch64 \
  -o bootstrap_arch x86_64 \
  build \
  --ignore-project-artifact-remotes \
  --ignore-project-source-remotes \
  mesa.bst
```

After correcting a failed element, resume without rebuilding successful
artifacts by adding `--retry-failed`:

```sh
bst --no-colors \
  -o target_arch aarch64 \
  -o bootstrap_arch x86_64 \
  build \
  --retry-failed \
  --ignore-project-artifact-remotes \
  --ignore-project-source-remotes \
  mesa.bst
```

This does not disable the local BuildStream cache. Remove the two `--ignore`
options when useful compatible artifacts have been published to a configured
remote.

The first run may consume tens of gigabytes while bootstrapping the aarch64
SDK. It is resumable: BuildStream retains completed source and artifact cache
entries. An intentional termination can print return code 130 for jobs that
were in flight; distinguish those signal-induced messages from the final
pipeline failure count.

## Provisional Freedesktop SDK ACL workaround

The first full cross build failed in
`freedesktop-sdk.bst:bootstrap/acl.bst`. The in-progress build was resumed by
changing its generated staged-junction copy from:

```yaml
- |
  mkdir tmp-build
  cd tmp-build
  ../configure
  cd po
  make
```

to:

```yaml
- |
  mkdir tmp-build
  cd tmp-build
  CFLAGS="%{build_flags}" CXXFLAGS="%{build_flags}" ../configure
  cd po
  make
```

Files below `.bst/staged-junctions/` are generated cache state, so this is not
a repository fix and may disappear when BuildStream restages the junction.
After the current build finishes, carry the change as a reviewed patch against
Freedesktop SDK's `elements/bootstrap/acl.bst` (or submit it upstream), then
revalidate the affected cache keys. Do not edit generated staged-junction
files as the long-term solution.

The KGSL prefix is kept in the top-level project's `elements/config.yml`.
Do not patch the equivalent file inside the SDK junction: doing so changes the
junction identity and invalidates otherwise reusable Freedesktop SDK artifact
cache keys.

Do not publish the resulting OSTree repository before completing
`docs/TESTING.md`.
