# Verification

Run the narrowest relevant Workshop verification for the changed area, then
broaden when risk or blast radius warrants it. Report skipped checks and
residual risk clearly.

## Standard Loops

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
```

## Verification Matrix

| Change type | Narrow verification | Broader verification |
| --- | --- | --- |
| Shell wrapper runtime | `workshop run agy-sdk -- test` | `workshop run agy-sdk -- lint` |
| SDK hooks | `workshop run agy-sdk -- test-integration` | `workshop run agy-sdk -- lint` |
| SDKcraft metadata | `workshop run agy-sdk -- yamllint` | `workshop run agy-sdk -- build` |
| SDK runtime behavior | `workshop run agy-sdk -- test` | `workshop run agy-sdk -- build` and `test-integration` |
| Wiki context only | `git -C .wiki pull --ff-only` | no wiki edits |
| Wiki update proposal | review proposal against current `.wiki/` content | no wiki commit |
| Direct wiki edit | `git -C .wiki status --short` | separate `.wiki/` commit and push |

## Area References

- SDK/Wrapper runtime: `workshop run agy-sdk -- test`.
- SDKcraft metadata: `workshop run agy-sdk -- yamllint` and `workshop run agy-sdk -- build`.
- Wiki: follow [../docs/wiki-workflow.md](../docs/wiki-workflow.md).
