# Contributing

This repository follows the same branch shape used by Canonical Workshop SDKs
such as `canonical/copilot-sdk`.

## Branches

### `main`

`main` is the development and Renovate branch.

It contains:

- the SDK source files
- tests
- `VERSION`
- `renovate.json`
- Renovate workflows
- build and upload workflow definitions

Renovate runs from `main` and opens version update pull requests against the
version branch.

### `latest`

`latest` is the published version branch for the `latest/stable` channel.

It contains the SDK source files, tests, `VERSION`, and build/upload workflows.
It intentionally does not contain the scheduled Renovate workflow, because
Renovate should be coordinated from `main` rather than running independently on
the version branch.

Pushes to `latest` may trigger SDK build/upload automation, and local manual
publishing should also be done from `latest`.

## Why the split exists

Workshop SDK publishing is track-based. The `latest` branch maps to the
`latest` store track, while `main` owns repository maintenance and Renovate
configuration. Keeping Renovate on `main` avoids duplicate automation and keeps
version update policy in one place. Keeping the publishable SDK on `latest`
makes it clear which branch is released to `latest/stable`.

## Applying changes

For SDK source, hook, README, and test changes:

1. Make and validate the change on `latest`.
2. Commit it on `latest`.
3. Cherry-pick the commit to `main`.
4. Push both branches.

Example:

```bash
git checkout latest
# edit files
bash tests/unit/agy-wrapper.sh
shellcheck hooks/* bin/agy tests/unit/agy-wrapper.sh
sdkcraft test --list
git add -A
git commit -m "Describe the SDK change"

git checkout main
git cherry-pick <commit-from-latest>

git push origin latest main
```

For Renovate-only changes, edit `main` first. If the change affects publishing
or SDK behavior, also apply it to `latest` deliberately.

## Local validation

Run the fast checks before pushing:

```bash
bash tests/unit/agy-wrapper.sh
shellcheck hooks/* bin/agy tests/unit/agy-wrapper.sh
sdkcraft test --list
```

Run the full integration suite before publishing when the change affects
`sdkcraft.yaml`, hooks, tests, or wrapper behavior:

```bash
sdkcraft test
```

## Manual publishing

Manual publishing should be done from `latest`.

For an amd64-only local release:

```bash
git checkout latest
rm -f *.sdk
sdkcraft pack --build-for amd64
sdkcraft upload agy_amd64.sdk --release latest/stable
```

Use `sdkcraft revisions agy` afterward to verify the released revision.
