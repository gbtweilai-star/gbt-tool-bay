# tool_bay

**One capability bit from GBT V8, packaged standalone.** No. 309 of 341,
`tentacle` domain (Tentacle).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 装备坞：触手「自配装备」走的那道门。白名单 15 件（本仓自定口径），每件状态靠**现跑探针**得出（没探针的如实报「无探针」，不得报已装）。install 三态：① 已在位（不耗票）② 需授权接上（screen/ui_tree/comfyui，**真过 auth_gate 的 check_and_consume**，没票如实报 needs_grant）③ 第三方件需主人装（**不代下、也不为此耗票**）。每装一次落账 state/tool_bay.jsonl。op=state 读类，install 写类。

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-tool-bay.git
cd gbt-tool-bay
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_tool_bay info                  # capability card
python -m gbt_tool_bay spec --json           # machine-readable contract
python -m gbt_tool_bay check --payload '{}'
python -m gbt_tool_bay run   --payload '{}'
```

Real `info` output from this machine:

```text
tool_bay  (tentacle)  v1.0.0
----------------------------------------
装备坞：触手「自配装备」走的那道门。白名单 15 件（本仓自定口径），每件状态靠**现跑探针**得出（没探针的如实报「无探针」，不得报已装）。install 三态：① 已在位（不耗票）② 需授权接上（screen/ui_tree/comfyui，**真过 auth_gate 的 check_and_consume**，没票如实报 needs_grant）③ 第三方件需主人装（**不代下、也不为此耗票**）。每装一次落账 state/tool_bay.jsonl。op=state 读类，install 写类。

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : screen, ui_tree, comfyui
```

Wire a real implementation:

```python
from gbt_tool_bay import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`screen`、`ui_tree`、`comfyui`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `tool_bay` |
| domain | `tentacle` |
| handler | `tool_bay` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [tentacle/tool_bay](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/tentacle/tool_bay.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
