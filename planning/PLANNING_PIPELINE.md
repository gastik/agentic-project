# Planning Pipeline

## Inputs
- documented idea/specification
- repository state
- Repository Capability Contract
- existing project documentation and ADRs

## Outputs
- normalized requirements
- ambiguity and assumption register
- repository gap analysis
- architecture impact report
- implementation strategy
- atomic coding-agent tasks
- dependency DAG
- requirement traceability matrix
- readiness report
- planning evidence manifest
- development handoff

## Stages
1. Idea intake
2. Specification normalization
3. Repository discovery
4. Gap analysis
5. Architecture impact analysis
6. Implementation strategy
7. Task decomposition
8. Dependency graph
8b. Task generation
9. Requirement coverage gate
10. Task readiness gate
11. Development handoff

## Failure conditions
The pipeline must fail before handoff if required requirements are uncovered, dependencies are cyclic, tasks are not testable, validation is undefined, task scope is ambiguous, or unresolved design decisions are delegated to coding agents.
