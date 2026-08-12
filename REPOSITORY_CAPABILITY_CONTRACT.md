# Repository Capability Contract

This file is a template. Step 0 should populate it for the target repository.

## Repository identity

- Repository:
- Primary language(s):
- Package manager(s):
- Build system:
- Runtime version(s):

## Canonical commands

### Install

```text
<command>
```

### Build

```text
<command>
```

### Test

```text
<command>
```

### Lint

```text
<command>
```

### Type check

```text
<command>
```

### Documentation validation

```text
<command>
```

### Documentation generation

```text
<command>
```

## Repository layout

| Path | Purpose | Writable by documentation agents |
|---|---|---|
| `docs/` | Project documentation | Yes |
| `README.md` | Project entry documentation | If assigned |
| `src/` | Application source | No |
| `tests/` | Tests | No |

## Authoritative generated artifacts

List generated documentation or schemas that must not be hand-edited.

## Forbidden operations

List repository-specific commands or paths that documentation agents must not modify.

## Notes

The pipeline must not guess missing commands. Unknown capabilities must be marked `UNKNOWN`.
