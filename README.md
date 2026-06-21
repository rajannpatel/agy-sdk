# Google Antigravity CLI (agy) SDK for Workshop

This SDK provides the Google Antigravity CLI (agy) inside a Canonical Workshop environment. It provides global access to the agy binary and persists credential configuration between workshop updates.

---

## Reference workshop

A minimal workshop:

```yaml
# workshop.yaml
name: dev
base: ubuntu@26.04
sdks:
  - name: agy
    channel: latest/stable

actions:
  agy-prompt: agy -p "$@"
  agy-sandbox: agy -p "$@" --sandbox
```

This demonstrates a basic environment setup to execute Antigravity CLI tasks
using `agy`, including reusable actions for headless prompts.

---

## Using the SDK

### Prerequisites, project layout

1. **Google Account**

   Since the Antigravity CLI requires Google authentication, you must complete the OAuth process when launching the CLI for the first time.

2. **Headless environment authentication**

   Because the workshop container runs in a headless environment (where native desktop keyrings are isolated), you will need to sign in interactively.

3. **No specific project layout is needed.**

### Primary workflow

Once the workshop is ready:

```bash
workshop shell
agy
```

This opens an interactive shell session inside the workshop container.

To run a single command (for example, the diagnostic tool):

```bash
workshop exec -- agy doctor
```

All credentials and settings are persisted under `/home/workshop/.gemini`, which is backed by persistent Workshop storage by default. Subsequent refreshes or updates will not require re-authentication.

### Run headless tasks

For non-interactive runs, pass the prompt with `-p`:

```bash
workshop exec -- agy -p "implement this markdown.md file"
```

If the task may need file edits or commands, configure permission handling up
front so the job doesn't hang waiting for an interactive prompt.

Use sandbox mode for automatic progress within stricter execution boundaries:

```bash
workshop exec -- agy -p "implement this markdown.md file" --sandbox
```

For trusted one-off jobs, use the bypass flag:

```bash
workshop exec -- agy -p "implement this markdown.md file" --dangerously-skip-permissions
```

To change the default permission behavior globally, launch the interactive TUI:

```bash
workshop shell
agy
```

Then use `/permissions` or `/config` and set the default permission behavior.

### Verify from the command line

To confirm the SDK is working:

```bash
workshop exec -- agy --version
```

---

## Plugs (resources this SDK consumes)

### `gemini-config`

- Interface: `mount`
- Workshop target: `/home/workshop/.gemini`
- Purpose: Preserves credential information and user settings directories between workshop updates. By default, it is backed by persistent Workshop storage, but can optionally be remounted to a host directory. To mount your existing host `~/.gemini` configuration into the workshop, stop the workshop first, remount, then start it again:

  ```bash
  workshop stop <workshop-name>
  workshop remount <workshop-name>/agy:gemini-config ~/.gemini
  workshop start <workshop-name>
  ```

---

## Slots (resources this SDK provides)

This SDK doesn't define any slots.

---

## Documentation and guidance

- [Upstream official documentation](https://antigravity.google/)
- [Workshop documentation](https://ubuntu.com/workshop/docs/)

---

## Community and support

- Upstream project: [Google Antigravity](https://antigravity.google/)
- Workshop forum: [Discourse](https://discourse.ubuntu.com/)
- Please review our [Code of Conduct](https://ubuntu.com/community/ethos/code-of-conduct) before participating.

---

## Contributions

All contributions, including code, documentation updates, and issue reports, are welcome!

- Open issues or pull requests on the official repository.

---

## License and copyright

Copyright 2026 Rajan Patel.

This repository's wrapper code, configuration (`sdkcraft.yaml`), integration tests, and hooks are licensed under the [MIT License](./LICENSE).

The Google Antigravity CLI binary itself is proprietary and subject to the [Google Terms of Service](https://antigravity.google/terms).
