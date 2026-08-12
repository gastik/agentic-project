# Coding Task Contract

Every task released to a coding agent must contain:

- Task ID
- Title
- Task type
- Objective
- Requirement sources
- Dependencies
- Repository scope
- Required behavior
- Interfaces affected
- Acceptance criteria
- Tests required
- Validation commands
- Evidence required
- Out of scope
- Completion conditions

## Task types
FEATURE, INFRASTRUCTURE, MIGRATION, VALIDATION, REFACTOR.

## Atomicity
One task represents one coherent, independently verifiable repository change.

## Scope
Every task defines allowed and forbidden paths, whether new files are allowed, and whether dependency changes are allowed. Unrelated files and new dependencies are forbidden by default.

## Coding-agent decision boundary
Coding agents may make local implementation choices, but must not independently decide product behavior, public API semantics, persistence model, security model, service boundaries, cross-component architecture, migration policy, or compatibility policy.

## READY gate
A task is READY only when:
- [ ] Objective is explicit
- [ ] Requirement source is identified
- [ ] Repository scope is bounded
- [ ] Dependencies are known
- [ ] Required behavior is explicit
- [ ] Out-of-scope behavior is explicit
- [ ] Acceptance criteria are objectively testable
- [ ] Required tests are described
- [ ] Validation commands are known
- [ ] Evidence requirements are defined
- [ ] No unresolved design decision is delegated to the coding agent
