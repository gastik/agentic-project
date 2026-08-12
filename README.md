# Project Documentation Pipeline

This package defines an evidence-driven, agentic documentation pipeline designed to operate alongside a software development pipeline.

## Core principles

- Documentation is treated as a first-class engineering artifact.
- Repository state is the primary source of technical truth.
- Documentation agents are read-only with respect to application/source code.
- Technical claims must be supported by repository evidence.
- Documentation drift must be detected explicitly.
- Every documentation run produces an evidence manifest.
- Commands, paths, interfaces, configuration keys, and examples must be validated before publication.
- Development agents should emit a Documentation Impact Manifest that becomes an input to this pipeline.

## Pipeline stages

1. Repository capability discovery
2. Documentation inventory
3. Documentation drift analysis
4. Documentation impact analysis
5. Documentation planning
6. Specialist documentation agents
7. Technical verification
8. Documentation review
9. Evidence gate
10. Final documentation index

See `PIPELINE.md` for the execution model.

## Planning / Task Generation

The package now includes an Idea -> Coding Tasks planning pipeline under `planning/`. It converts a documented idea into normalized requirements, repository gap analysis, architecture impact, implementation strategy, atomic coding-agent tasks, dependency DAG, requirement traceability, readiness gating, and development handoff.
