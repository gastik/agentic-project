# Cyclic Software Architecture Review

## Purpose

Use this skill to critically review a software architecture, architecture proposal, migration plan, modernization plan, system redesign, or implementation strategy through repeated review-and-rework cycles until it reaches one of two explicit states:

- `GREEN` — the architecture is sufficiently coherent, implementable, safe, and evidenced for its stated purpose.
- `REWORK` — one or more material architectural defects, contradictions, unsupported assumptions, or unproven acceptance conditions remain.

This is a **general software architecture review process**. It is not tied to one domain, one requirements format, or one particular architecture style.

The process is intentionally cyclic:

```text
REVIEW INPUTS
    ↓
Understand system and decision context
    ↓
Construct architectural view
    ↓
Critical architecture review
    ↓
  GREEN? ───────── yes ───────→ accepted
    │
    no
    ↓
Atomic REWORK findings
    ↓
Constrained architectural revision
    ↓
Full-system regression review
    ↺
```

Continue until `GREEN` is reached or a genuine unresolved business/technical decision requires human authority.

---

# 1. Review philosophy

The goal is not to ask whether an architecture is elegant or whether the reviewer personally prefers it.

The goal is to determine whether the design:

- solves the stated problem;
- fits the actual current system and constraints;
- has clear component and responsibility boundaries;
- has a coherent data and integration model;
- satisfies the required quality attributes;
- has explicit failure and recovery behavior;
- can be deployed and operated safely;
- can evolve without creating unacceptable lock-in or migration risk;
- is testable and measurable;
- has understood trade-offs;
- is implementable by engineering teams or AI coding agents without guessing critical semantics.

Architecture review must separate:

```text
fact
requirement
constraint
design decision
assumption
risk
open question
```

Do not silently convert one into another.

---

# 2. When to use

Use this skill for:

- new system architecture;
- major subsystem design;
- monolith → services changes;
- service consolidation;
- cloud or infrastructure migration;
- data-platform redesign;
- AI/LLM system architecture;
- event-driven architecture;
- storage or consistency-model changes;
- security architecture changes;
- replacement of a legacy subsystem;
- phased modernization plans;
- architecture produced by another AI agent;
- architecture that will later be decomposed into implementation tasks.

The process can review either:

1. a **target architecture**, or
2. a **migration from current architecture to target architecture**.

---

# 3. Required inputs

The reviewer should gather as much of the following as exists.

## 3.1 Problem and goals

Understand:

- what problem the system must solve;
- primary users/actors;
- business outcome;
- required capabilities;
- expected scale;
- critical workflows;
- important non-goals.

If the problem statement is unclear enough that architectural correctness cannot be judged, record this as a blocking finding rather than inventing the goal.

## 3.2 Current-state evidence

When reviewing an existing system or migration, inspect the actual current state:

- repository structure;
- implementation;
- database schema;
- API contracts;
- runtime topology;
- deployment manifests;
- tests;
- operational documentation;
- current ADRs;
- known production constraints.

Repository/runtime evidence outranks assumptions about what the system currently does.

## 3.3 Proposed architecture

The design under review may include:

- architecture document;
- diagrams;
- ADRs;
- phased migration plan;
- component model;
- data model;
- API design;
- operational model;
- implementation strategy.

## 3.4 Constraints

Identify explicit constraints such as:

- language/runtime;
- cloud/platform;
- data residency;
- security/compliance;
- latency;
- throughput;
- availability;
- cost;
- deployment model;
- backward compatibility;
- team capabilities;
- migration downtime;
- dependency restrictions.

## 3.5 Authoritative sources when they exist

Some projects have formal normative specifications, accepted ADRs, contracts, or regulatory requirements. Others do not.

When authoritative sources exist, define precedence explicitly.

Example:

```text
1. Accepted product/system requirements
2. Accepted ADRs / architecture contract
3. Current implementation for factual current-state behavior
4. Proposed design
5. Reviewer inference
```

Formal requirement traceability is useful in these projects, but it is **one review technique**, not the architecture-review process itself.

---

# 4. Build the architecture model before judging it

Do not review isolated paragraphs.

Construct a coherent view of the proposed system.

At minimum identify:

```text
Actors / clients
System boundary
Major components
Responsibilities
State owners
Data stores
External dependencies
Synchronous interfaces
Asynchronous interfaces
Runtime/deployment units
Security boundaries
Failure boundaries
Observability path
Release/deployment path
```

For a migration also identify:

```text
Current architecture
Target architecture
Coexistence state
Migration steps
Compatibility boundaries
Rollback path
Cutover condition
Legacy retirement condition
```

If these cannot be reconstructed from the design, that itself may be a finding.

---

# 5. Architecture review dimensions

Review the design as a system. Use all dimensions that materially apply.

---

## 5.1 Problem fit and scope

Ask:

- Does the architecture solve the stated problem?
- Are important user/system workflows covered end to end?
- Is the architecture solving unrelated problems that increase complexity?
- Are non-goals respected?
- Does any major component exist without a clear requirement or operational reason?

Reject architecture that is technically elaborate but does not clearly serve the intended outcome.

---

## 5.2 System boundaries and responsibility allocation

Check:

- clear ownership of responsibilities;
- cohesion within components;
- coupling between components;
- duplicated business logic;
- hidden orchestration;
- circular dependencies;
- unclear authority over state;
- frontend/backend responsibility leakage;
- business rules implemented in infrastructure adapters.

A component should have a clear reason to change.

---

## 5.3 Domain and data model

Check whether the model can represent all required states without lossy encoding or hidden assumptions.

Review:

- identity;
- cardinality;
- invariants;
- state transitions;
- immutable vs mutable data;
- versioning;
- temporal history;
- ownership;
- retention;
- deletion semantics;
- derived vs authoritative data.

Do not accept prose-level capabilities that the persistence model cannot actually represent.

---

## 5.4 Interfaces and contracts

Review:

- API boundaries;
- commands vs queries;
- synchronous vs asynchronous behavior;
- schemas;
- compatibility/versioning;
- idempotency;
- pagination/streaming where relevant;
- error contracts;
- retry semantics;
- event contracts;
- ownership of validation.

Ask whether callers can use the system correctly without depending on undocumented behavior.

---

## 5.5 Integration architecture

Check:

- external systems;
- provider dependencies;
- queues/event brokers;
- databases;
- third-party APIs;
- filesystem/object storage;
- identity providers;
- model providers;
- caching layers.

For each external dependency ask:

```text
What happens when it is slow?
What happens when it fails?
What happens when it returns malformed data?
What happens when it is unavailable for hours?
Can the operation be retried safely?
```

---

## 5.6 Consistency and transactional behavior

Where state crosses components, inspect:

- transaction boundaries;
- partial failure;
- eventual consistency;
- duplicate delivery;
- stale reads;
- ordering assumptions;
- optimistic/pessimistic concurrency;
- compensating actions;
- exactly-once assumptions;
- idempotent replay.

Do not accept distributed designs that depend on implicit atomicity across systems.

---

## 5.7 Reliability and failure behavior

For each important workflow identify:

```text
success path
expected failure path
unexpected failure path
retry path
recovery path
manual intervention path
terminal state
```

Review:

- fail-open vs fail-closed behavior;
- durable checkpoints;
- worker/process restart;
- retries and backoff;
- poison messages;
- timeout handling;
- partial progress;
- last-known-good state;
- disaster recovery;
- backup/restore assumptions.

A design is incomplete if it describes only the successful path.

---

## 5.8 Performance and scalability

Review against expected scale rather than generic “scalability”.

Ask:

- expected request/job volume;
- data volume;
- concurrency;
- latency targets;
- throughput targets;
- large-item behavior;
- computational hotspots;
- memory pressure;
- database access pattern;
- N+1 behavior;
- fan-out;
- queue depth;
- model/API token or payload size;
- horizontal/vertical scaling constraints.

Require measurable performance assumptions where performance is material.

---

## 5.9 Security and privacy

Review:

- authentication;
- authorization;
- tenant isolation;
- trust boundaries;
- input validation;
- secrets;
- encryption;
- executable/untrusted content;
- injection paths;
- SSRF/path traversal/deserialization risks;
- dependency/provider data exposure;
- retention/deletion;
- audit events;
- least privilege;
- administrative override paths.

Security controls must be introduced **before or with** the feature that requires them, not later in the roadmap.

---

## 5.10 Observability and operability

The architecture must be diagnosable in production.

Review:

- structured logs;
- metrics;
- traces/correlation IDs;
- health/readiness;
- stage/job state;
- error categorization;
- operator dashboards;
- alerting;
- support diagnostics;
- runbooks;
- audit trails;
- provenance where automated decisions matter.

Ask:

> Can an operator explain why this operation failed or produced this result without reproducing production manually?

---

## 5.11 Deployment and release architecture

Review:

- build artifacts;
- environment configuration;
- deployment topology;
- migrations;
- backward compatibility;
- rolling deployment;
- feature flags;
- rollback;
- zero/low-downtime needs;
- version skew;
- release gates;
- immutable artifacts.

For migrations, verify that a rollback path exists at every high-risk transition.

---

## 5.12 Evolution and maintainability

Ask:

- Can components evolve independently where intended?
- Are interfaces stable enough?
- Is there unnecessary framework/provider lock-in?
- Are extension points explicit?
- Is complexity proportional to the problem?
- Are temporary migration structures clearly temporary?
- Is legacy retirement defined?
- Are multiple competing abstractions being introduced?

Avoid both premature abstraction and architecture that can only support today’s exact case.

---

## 5.13 Testability and verification

For every critical architectural claim ask:

> How will we know this is true?

Review the ability to test:

- domain invariants;
- component contracts;
- database behavior;
- concurrency;
- failure recovery;
- security boundaries;
- integrations;
- deployment behavior;
- end-to-end workflows;
- migration/cutover;
- rollback;
- performance limits.

Acceptance criteria should prove the architecture's behavior rather than merely prove that code executed.

---

## 5.14 Cost and complexity

Review:

- infrastructure cost;
- operational burden;
- provider/API cost;
- storage growth;
- human review/operations cost;
- complexity introduced per capability;
- number of runtime services;
- build/deploy complexity;
- likely support burden.

A more sophisticated architecture is not automatically better.

---

## 5.15 AI / probabilistic components, when applicable

If the system uses LLMs, embeddings, classifiers, ranking, computer vision, or other probabilistic components, additionally review:

- where probabilistic decisions are allowed;
- deterministic boundaries around model output;
- grounding/evidence requirements;
- structured output validation;
- model/provider abstraction;
- prompt/model versioning;
- evaluation datasets;
- confidence calibration;
- fallback/manual review;
- hallucination containment;
- data sent to providers;
- retry behavior;
- cost/token controls;
- reproducibility/provenance.

Never treat model confidence as system correctness without empirical calibration.

---

# 6. Architecture trade-off review

Every significant architectural decision should expose its trade-off.

For each major decision ask:

```text
Decision
Why chosen
Alternatives considered
What this optimizes
What this makes worse
Operational consequences
Migration consequences
Reversal cost
Evidence/assumption behind the decision
```

A design with no trade-offs is usually under-analyzed.

Do not mark a legitimate trade-off as a defect merely because another design is possible.

Mark it as a defect when:

- the downside contradicts a required quality attribute;
- the decision is based on a false current-state assumption;
- the decision has no mitigation for a critical known risk;
- a much simpler option satisfies the same constraints and the complexity has no justified benefit.

---

# 7. Migration review

When the design is a migration, review each phase as a valid architecture state rather than only reviewing the final state.

For every phase define:

```text
Entry assumptions
Changes introduced
Old/new coexistence model
Data compatibility
Traffic/workflow routing
Operational behavior
Failure behavior
Rollback behavior
Exit criteria
```

Check specifically for:

- dual-write hazards;
- schema compatibility;
- old/new version coexistence;
- partially migrated data;
- replay/reprocessing;
- immutable historical artifacts;
- feature-flag ownership;
- cutover authority;
- rollback after data-shape change;
- legacy retirement timing.

A migration plan is `REWORK` if an intermediate phase violates a critical safety or correctness invariant even when the final design is sound.

---

# 8. Evidence and assumption discipline

Every important architectural statement should be identifiable as one of:

```text
EVIDENCED FACT
REQUIREMENT / CONSTRAINT
DESIGN DECISION
ASSUMPTION
RISK
OPEN QUESTION
```

## Evidenced fact

Supported by repository, runtime, documentation, benchmark, measurement, or accepted source.

## Design decision

Chosen by the architecture. It must not be presented as an existing fact.

## Assumption

Potentially true but not yet proved. Material assumptions need validation or an explicit risk response.

## Risk

A known possible negative outcome requiring acceptance, mitigation, transfer, or avoidance.

## Open question

Cannot be resolved by architectural reasoning alone and requires authority/data outside the review.

This classification prevents plausible prose from hiding uncertainty.

---

# 9. Findings

Findings must be concrete and actionable.

Use:

```text
ID
Severity
Category
Architecture area / section
Observed design
Evidence
Why it matters
Required outcome
Acceptance evidence required
Must-not-regress constraints
```

Severity guidance:

## CRITICAL

Architecture cannot safely or correctly deliver the intended system, or violates a mandatory security/data-integrity constraint.

## HIGH

Major correctness, reliability, security, scalability, operability, or migration defect that must be resolved before acceptance.

## MEDIUM

Material design weakness that should be resolved or explicitly accepted with a documented trade-off.

## LOW

Minor architectural improvement; does not block `GREEN` unless the project's acceptance policy says otherwise.

Do not create findings for style preferences.

---

# 10. Verdict rules

Only two overall verdicts are allowed:

```text
GREEN
REWORK
```

Do not use:

- mostly green;
- conditional green;
- approved with comments;
- partial pass;
- looks good.

## 10.1 GREEN

`GREEN` means:

- the architecture solves the stated problem;
- major system boundaries are coherent;
- data ownership and state transitions are implementable;
- important interfaces are sufficiently defined;
- critical quality attributes are addressed;
- critical failure modes have safe behavior;
- security boundaries are adequate for the stated scope;
- deployment/operations are credible;
- migration phases are safe if applicable;
- critical architecture claims are verifiable;
- current-state assumptions used by the design are evidenced;
- no unresolved `CRITICAL` or `HIGH` finding remains;
- previous accepted semantics have not regressed;
- adversarial re-review finds no new blocking defect.

`GREEN` does **not** mean that every implementation detail is already designed.

It means the architecture is sufficiently complete and consistent that implementation can proceed without teams inventing critical system behavior.

## 10.2 REWORK

Return `REWORK` when any blocking issue remains, including:

- system goal not actually solved;
- responsibility or state ownership ambiguity;
- unrepresentable domain state;
- contradictory interfaces;
- unsafe failure behavior;
- invalid consistency assumption;
- unsupported scalability assumption;
- missing security boundary;
- unoperable deployment model;
- unsafe migration phase;
- unverifiable critical behavior;
- design based on false current-state assumptions;
- critical requirement omitted where formal requirements exist;
- architecture complexity without a justified purpose that materially increases risk.

One unresolved `CRITICAL` defect is sufficient for `REWORK`.

---

# 11. Rework process

Do not tell a rework agent merely to “improve the architecture”.

Each blocking finding becomes a bounded rework contract.

Example:

```text
AR-007 — HIGH

Category:
Reliability / state ownership

Section:
Background processing

Observed design:
The API writes a job row, publishes a queue message, and assumes only one
worker will process that job.

Why it matters:
The broker is at-least-once. Duplicate delivery can execute the operation
twice and produce conflicting artifacts.

Required outcome:
Define processing ownership and idempotent replay semantics. Duplicate
message delivery must converge on one authoritative job result.

Acceptance evidence:
Inject duplicate delivery and worker restart during processing. The system
must not produce duplicate authoritative outputs or contradictory terminal
states.

Must not regress:
Existing retry semantics and historical job auditability.
```

The rework agent must fix the required outcome while preserving previously accepted behavior.

---

# 12. Full-system re-review after every cycle

After rework, review the **entire architecture again**, not only modified sections.

Each cycle should repeat:

```text
1. Problem-fit review
2. System-boundary review
3. Data/state review
4. Interface/integration review
5. Consistency/concurrency review
6. Reliability/failure review
7. Performance/scalability review
8. Security/privacy review
9. Operability/observability review
10. Deployment/release review
11. Maintainability/evolution review
12. Testability/acceptance review
13. Migration review when applicable
14. Regression review against previously accepted decisions
15. Adversarial pass
```

A local fix can create a new defect elsewhere. Whole-system re-review is what makes the process cyclic rather than a list of independent comments.

---

# 13. Adversarial review before GREEN

Before final acceptance, run one pass whose explicit purpose is to invalidate the candidate architecture.

Ask questions such as:

- Which component has ambiguous ownership?
- What happens if every external dependency becomes unavailable?
- Which operation is assumed to be atomic but is not?
- What happens on duplicate requests or duplicate messages?
- What happens during partial deployment/version skew?
- Can stale data overwrite newer state?
- Can retries create duplicate side effects?
- Can one tenant/user access another's data?
- What happens at 10x the expected load?
- What grows without bound?
- What cannot be diagnosed from production telemetry?
- Which failure requires a manual database correction?
- Which migration phase cannot be rolled back?
- Which design statement is actually an unverified assumption?
- Which architecture claim has no acceptance test or measurement?
- Which mechanism is more complex than the problem requires?

If a new `CRITICAL` or `HIGH` finding appears, return to `REWORK`.

---

# 14. Optional formal traceability

Formal requirement traceability is recommended when the project has:

- regulatory requirements;
- contractual requirements;
- a normative architecture specification;
- safety-critical behavior;
- a large migration specification;
- multiple competing source documents;
- AI agents that need precise implementation contracts.

In those cases, maintain a requirement-to-architecture-to-test matrix.

Example:

| Requirement | Architecture mechanism | Component/phase | Acceptance evidence | Status |
|---|---|---|---|---|
| R-001 | ... | ... | ... | PASS |

This is an **optional assurance mechanism**. Do not make the entire review process depend on a requirements ledger when the project does not need one.

---

# 15. Cycle history

Keep a compact permanent record of review cycles.

Example:

```text
Cycle 1
Verdict: REWORK
Critical/high findings: 11

Cycle 2
Verdict: REWORK
Resolved: 11
New findings from whole-system regression: 3
Regressions: 0

Cycle 3
Verdict: GREEN
Open critical/high findings: 0
Adversarial pass: PASS
```

Record at minimum:

```text
cycle number
architecture revision/hash
review scope
verdict
resolved findings
new findings
regressions
open decisions
adversarial result
```

Do not erase previous findings. The history explains how architectural acceptance was reached.

---

# 16. Execution roles

The process can be performed by one capable reviewer, but stronger independence comes from separate roles.

Recommended roles:

```text
Architecture Reviewer
- reconstructs the system
- performs full review
- issues GREEN/REWORK

Rework Architect
- receives blocking findings
- revises the design
- must preserve accepted decisions

Adversarial Reviewer
- tries to invalidate the candidate GREEN result
- does not optimize or redesign unless reporting a defect
```

Optional specialists may review:

```text
Security
Data architecture
Reliability/SRE
Performance
AI/ML
Cloud/infrastructure
Compliance/privacy
```

The final architecture reviewer remains responsible for system-level coherence across specialist findings.

---

# 17. Expected review artifacts

A complete cyclic architecture review should produce:

## A. Architecture review report

```text
Scope
System summary
Current-state facts where applicable
Key design decisions
Quality-attribute assessment
Trade-offs
Findings
Overall verdict
```

## B. Rework findings

Atomic blocking findings with required outcomes and evidence.

## C. Revised architecture

A new revision of the design, not an overwritten review history.

## D. Cycle history

Every REWORK/GREEN decision and its findings.

## E. Optional traceability matrix

Only when the project requires formal requirement-level assurance.

---

# 18. Canonical architecture reviewer prompt

```text
You are the critical software architecture reviewer.

Your task is to determine whether the architecture is coherent,
implementable, safe, operable, and sufficient for its stated problem.

Do not redesign the system unless the verdict is REWORK.
Do not mark preferences as defects.
Do not assume current-system behavior without evidence.
Do not silently resolve contradictions or missing decisions.

First understand:
- the problem and goals;
- current architecture, when relevant;
- proposed architecture;
- constraints;
- major workflows;
- quality attributes.

Then review the architecture across all materially relevant dimensions:

1. problem fit and scope
2. component boundaries and responsibilities
3. domain/data model
4. interfaces and contracts
5. integrations and dependencies
6. consistency/concurrency/transactions
7. reliability and failure behavior
8. performance and scalability
9. security and privacy
10. observability and operability
11. deployment and release model
12. evolution and maintainability
13. testability and acceptance evidence
14. migration safety, when applicable
15. cost and complexity
16. probabilistic/AI boundaries, when applicable

For important statements distinguish:
FACT
REQUIREMENT/CONSTRAINT
DESIGN DECISION
ASSUMPTION
RISK
OPEN QUESTION

Return exactly one overall verdict:

GREEN
or
REWORK

GREEN is allowed only when no unresolved CRITICAL or HIGH architectural
finding remains and the architecture is sufficiently defined that
implementation can proceed without inventing critical behavior.

If REWORK, produce atomic findings with:

ID
Severity
Category
Architecture section
Observed design
Evidence
Why it matters
Required outcome
Acceptance evidence required
Must-not-regress constraints

After rework, review the complete architecture again, not only the changed
sections.

Before issuing GREEN, perform an adversarial pass whose purpose is to find
a blocking reason the architecture should not be accepted.
```

---

# 19. Canonical rework prompt

```text
You are the architecture rework agent.

Inputs:
- the current architecture document;
- blocking architecture-review findings;
- known current-system evidence;
- accepted design decisions that must not regress.

Your task is to resolve the findings with the smallest coherent
architectural change that satisfies the required outcomes.

Do not perform a free redesign.
Do not change unrelated accepted decisions unless required for consistency.
Do not hide an unresolved issue behind vague wording.
Do not convert assumptions into facts.

For every finding:
1. identify affected architecture areas;
2. make the required architectural correction;
3. propagate consequences through data, APIs, runtime, security,
   reliability, operations, migration and testing as applicable;
4. add concrete acceptance evidence;
5. preserve must-not-regress constraints;
6. record any new trade-off or open decision introduced by the change.

Produce a new architecture revision for full re-review.
```

---

# 20. Stop conditions

The cycle normally stops only on `GREEN`.

Stop without GREEN only when a blocking question cannot be resolved from available evidence and requires an authoritative decision, for example:

- contradictory business goals;
- unknown compliance requirement;
- unavailable production-scale data needed to choose a design;
- undecided consistency/availability trade-off owned by the business;
- missing authority over data retention or provider usage;
- two mutually incompatible requirements with no precedence.

Record:

```text
BLOCKED_ARCHITECTURE_DECISION
Question
Why architecture cannot decide it safely
Available options
Trade-offs
Required decision owner
Affected findings
```

Do not fabricate the answer merely to force GREEN.

---

# 21. Proven cyclic pattern

A useful pattern for architecture work is:

```text
Review candidate architecture
        ↓
REWORK findings
        ↓
Bounded revision
        ↓
Whole-system re-review
        ↓
New findings caused by deeper inspection
        ↓
Bounded revision
        ↓
Adversarial final pass
        ↓
GREEN
```

A real review may require several cycles. That is expected.

The value of the process is not the number of findings in the first pass. The value is that each cycle reduces unresolved architectural risk **without losing previously accepted system behavior**, and that `GREEN` is reached only after the complete architecture survives a fresh critical review.