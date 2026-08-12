# Documentation Pipeline

## Inputs

The pipeline consumes:

- repository checkout;
- Repository Capability Contract;
- existing documentation;
- development Evidence Manifest, when available;
- Documentation Impact Manifest, when available;
- source code and configuration in read-only mode;
- build/test/lint outputs when relevant.

## Execution order

### Stage 0 — Capability Contract

Load and validate `REPOSITORY_CAPABILITY_CONTRACT.md`.

The contract is authoritative for:

- build commands;
- test commands;
- lint commands;
- repository layout;
- package managers;
- runtime versions;
- documentation locations;
- generated-documentation commands;
- API/schema generation commands;
- forbidden paths;
- supported validation commands.

If the contract is missing or materially incomplete, the pipeline must report the gap before publishing technical documentation.

### Stage 1 — Inventory

Agent: `agents/01-inventory.md`

Produces:

- documentation file inventory;
- document ownership/category map;
- missing-document candidates;
- stale-document candidates;
- generated vs manually maintained classification.

### Stage 2 — Drift Analysis

Agent: `agents/02-drift-analysis.md`

Compares documentation with repository state.

Produces `reports/DOCUMENTATION_DRIFT_REPORT.md`.

### Stage 3 — Impact Analysis

Agent: `agents/03-impact-analysis.md`

Consumes repository changes and, if present, development evidence.

Produces or validates `manifests/DOCUMENTATION_IMPACT_MANIFEST.md`.

### Stage 4 — Documentation Plan

Agent: `agents/04-planner.md`

Creates an ordered plan of documentation changes.

No documentation content is written at this stage.

### Stage 5 — Specialist Writers

Specialists operate independently on assigned scopes:

- architecture;
- developer documentation;
- API/interface documentation;
- operational documentation;
- feature documentation;
- user documentation.

Each agent may write only documentation files explicitly assigned by the plan.

### Stage 6 — Technical Verification

Agent: `agents/11-verification.md`

Validates factual claims using repository evidence and repository capability commands.

### Stage 7 — Review

Agent: `agents/12-review.md`

Checks:

- correctness;
- completeness;
- consistency;
- duplication;
- terminology;
- broken references;
- unsupported claims;
- drift remaining after changes.

### Stage 8 — Evidence Gate

Agent: `agents/13-evidence-gate.md`

The run fails if significant technical claims lack evidence.

### Stage 9 — Final Index

Agent: `agents/14-index.md`

Updates the canonical documentation index only after the evidence gate succeeds.

## Failure rules

The pipeline must fail rather than publish documentation when:

- a required command cannot be verified;
- referenced files or paths do not exist;
- API/interface details contradict code or schemas;
- configuration documentation contradicts repository configuration;
- architecture claims cannot be supported;
- generated documentation is manually edited where generation is authoritative;
- the evidence manifest is missing or incomplete.

## Source-of-truth priority

When sources disagree:

1. executable repository state;
2. schemas/contracts/generated artifacts;
3. repository capability contract;
4. tests;
5. current configuration;
6. development evidence manifest;
7. existing documentation;
8. comments;
9. assumptions.

Assumptions may never be published as facts.
