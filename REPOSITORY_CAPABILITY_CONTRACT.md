# Repository Capability Contract

This contract defines the authorized capabilities, commands, and layout for the target repository to enforce safe and deterministic agentic operations.

## Repository identity

- Repository: LED Perimeter Advertising Platform
- Primary language(s): TypeScript (Frontend), Python (Backend)
- Package manager(s): npm (Node.js), pip (Python)
- Build system: Next.js build system
- Runtime version(s): Node.js 20+, Python 3.10+

## Canonical commands

### Install

```bash
npm install
pip install -r requirements.txt
```

### Build

```bash
npm run build
```

### Test

```bash
npm test
pytest
```

### Lint

```bash
npm run lint
flake8 .
```

### Type check

```bash
npx tsc --noEmit
mypy .
```

### Documentation validation

```text
UNKNOWN
```

### Documentation generation

```text
UNKNOWN
```

## Repository layout

| Path | Purpose | Writable by documentation agents |
|---|---|---|
| `docs/` | Project documentation | Yes |
| `planning/` | Planning artifacts and orchestration | Yes |
| `README.md` | Project entry documentation | If assigned |
| `frontend/` | Next.js application source | No |
| `backend/` | Python backend source | No |

## Authoritative generated artifacts

- `frontend/.next/` - Next.js build outputs
- `planning/output/` - Automated planning artifacts
- `__pycache__/` - Python compiled bytecode

## Forbidden operations

- Modifying contents inside `frontend/.next/` or `node_modules/`.
- Directly editing the `REPOSITORY_CAPABILITY_CONTRACT.md` without authorization.

## Notes

The pipeline must not guess missing commands. Unknown capabilities must be marked `UNKNOWN`.
