# Documentation Contract

Every documentation agent must obey this contract.

## Allowed actions

An agent may:

- read any repository file required to establish technical facts;
- execute non-destructive inspection and validation commands allowed by the Repository Capability Contract;
- create or modify assigned documentation files;
- create evidence, drift, impact, and review manifests;
- create documentation-only diagrams or generated assets in approved documentation paths.

## Prohibited actions

An agent must not:

- modify application code;
- modify tests;
- modify build configuration;
- install dependencies;
- add libraries;
- change runtime behavior;
- change schemas to match documentation;
- suppress validation failures;
- invent commands, interfaces, configuration values, or behavior;
- copy unsupported claims from existing documentation.

If implementation changes are required, emit a finding for the development pipeline.

## Evidence requirement

Every material technical claim introduced or changed must be traceable to evidence.

Examples of material claims:

- API routes;
- parameters;
- response formats;
- supported runtime versions;
- environment variables;
- service dependencies;
- build/test commands;
- deployment steps;
- permissions;
- data flows;
- storage behavior;
- retry/failure behavior;
- security boundaries.

## Scope discipline

Agents may modify only files assigned by the documentation plan.

If another document needs modification, record it as a follow-up item instead of editing it opportunistically.
