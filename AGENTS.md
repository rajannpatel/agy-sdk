# Agent Execution Rules for agy-sdk

## Principle

The editor process starts in the host development environment, but project
tools and terminal-backed agent work must run in the Workshop LXD container.
Every shell command an agent runs for this project must enter Workshop. Treat
any direct host project command as misconfigured and stop.

The committed `tools/workshop-shell` wrapper is the Workshop terminal entry
point. It starts an interactive Workshop shell and routes ad hoc `-c` commands
into Workshop. Never install or run project tools directly on the host.

Detailed policy lives in:

- [Workshop confinement](.agents/security/workshop-confinement.md)
- [Role bootstrap](.agents/bootstrap.md)
- [Commands](.agents/commands.md)
- [Verification](.agents/workflows/verification.md)
- [Git boundary](.agents/policies/git-boundary.md)
- [Formatting](.agents/policies/formatting.md)
- [Scope and hygiene](.agents/policies/scope-and-hygiene.md)
- [Delegation workflow](.agents/workflows/delegation.md)
- [Editor preflight](.agents/workflows/editor-preflight.md)
- [Model selection](.agents/models/selection.md)

## Required Bootstrap

Before planning, editing, reviewing, or running project checks:

```bash
workshop run agy-sdk -- agent-role <role>
workshop run agy-sdk -- context
```

If the role is not explicitly assigned, act as Router. A prompt that says
`You are the <role> for agy-sdk` is a complete role assignment. See
[.agents/bootstrap.md](.agents/bootstrap.md) and the role files under
[.agents/roles/](.agents/roles/).

## Hard Rules

- Run all project shell commands through Workshop.
- Do not run `sdkcraft`, `shellcheck`, or `yamllint` directly on the host.
- AI agent Git inspection runs inside Workshop.
- Commits and tags are maintainer operations unless explicitly assigned.
- Agents must never run `git push` from inside Workshop. If asked to push,
  stop before pushing and direct the user to push from the host or maintainer
  environment.
- Do not add SSH host keys, update `known_hosts`, configure Workshop SSH
  trust, or otherwise prepare Workshop credentials or trust solely to enable
  pushing from Workshop.
- Generated artifacts (`.sdk` files, coverage reports, etc.) stay out of commits
  unless the task explicitly asks for them.
- Preserve unrelated user changes. Do not revert or overwrite work you did not
  make.
- Choose Workshop terminal mode or native panel mode in uncommitted personal
  preferences. This choice never changes the Workshop execution boundary.
- Follow `.agents/models/selection.md`. Do not inspect secrets, API keys, or
  private provider configuration to discover model access.

## Common Commands

Run project tools through Workshop from the host:

```bash
workshop run agy-sdk -- agent-role <role>
workshop run agy-sdk -- context
workshop run agy-sdk -- doctor
workshop run agy-sdk -- test
workshop run agy-sdk -- test-integration
workshop run agy-sdk -- lint
workshop run agy-sdk -- yamllint
workshop run agy-sdk -- build
workshop run agy-sdk -- clean
workshop run agy-sdk -- shell
```

See [.agents/commands.md](.agents/commands.md) for the canonical action list,
Workshop-provided agent tools, and lower-level command references.

## Verification Summary

For normal edits:

```bash
workshop run agy-sdk -- context
workshop run agy-sdk -- test
workshop run agy-sdk -- lint
```

For packaging/runtime changes:

```bash
workshop run agy-sdk -- build
workshop run agy-sdk -- test-integration
```

For pre-submit:

```bash
workshop run agy-sdk -- test
workshop run agy-sdk -- test-integration
workshop run agy-sdk -- lint
workshop run agy-sdk -- yamllint
```

See [.agents/workflows/verification.md](.agents/workflows/verification.md) for
the verification matrix and area-specific checks.

## Wiki Repository

Follow [.agents/docs/wiki-workflow.md](.agents/docs/wiki-workflow.md). Wiki
edits are not part of the main repository branch unless a task explicitly
assigns direct wiki edit mode.

## Secrets

- Do not read, print, or commit API keys or tokens.
- Pass model choices at runtime:
  `workshop run --env CLAUDE_MODEL=haiku agy-sdk -- context`
