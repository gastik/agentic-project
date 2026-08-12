# Documentation Standards

## Correctness

Technical statements must match the current repository state.

## Verifiability

Prefer statements that can be tied to:

- source paths;
- schemas;
- configuration;
- tests;
- executable commands;
- generated artifacts.

## Commands

Every published command must either:

- be present in the Repository Capability Contract; or
- be directly verifiable from repository configuration.

Commands must never be invented from ecosystem conventions.

## Paths

Every repository path included in documentation must be checked for existence unless explicitly described as a path created later by the user.

## Examples

Examples must be:

- syntactically valid;
- consistent with current interfaces;
- clearly identified if illustrative rather than executable.

## Terminology

Use repository-native names for services, components, modules, entities, and workflows.

## Duplication

Do not duplicate detailed technical instructions across many documents. Prefer one authoritative document and link to it.

## Uncertainty

Unknown facts must be written as findings or open questions, not silently converted into confident prose.
