# Commands

Run project tools through Workshop from the host. Prefer these named actions
over lower-level commands.

## Workshop Actions

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

Repo-local slash commands such as `/tdd` and `/diagnose`
are documented workflows, not Workshop actions.

## Workshop Agent Tools

The Workshop SDK provides common agent utilities inside the container:
`rg`, `fd`, `tree`, `jq`, `yq`, `git`, `gh`, `sed`, `awk`, `python3`, `uv`, `curl`,
`wget`, and `make`.

## Lower-Level References

These are the lower-level commands behind named actions. Prefer
the named Workshop actions above. Run these only inside the Workshop container
or CI environment, not directly on the host:

```bash
bash tests/unit/agy-wrapper.sh
shellcheck hooks/* bin/agy tests/unit/agy-wrapper.sh
yamllint -d "{extends: relaxed, rules: {line-length: disable}}" sdkcraft.yaml workshop.yaml
sdkcraft test
sdkcraft pack --build-for amd64
```
