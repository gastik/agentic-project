# Cyclic Software Architecture Acceptance Review

## Purpose

Use this skill to critically review a software architecture, migration plan, implementation strategy, or architectural design **against authoritative source requirements and actual repository evidence** until it reaches one of two explicit states:

- `GREEN` — critically accepted against the normative target.
- `REWORK` — at least one critical semantic, architectural, migration, reliability, security, or acceptance-proof defect remains.

This is not a style review and not a general architecture brainstorming exercise. The purpose is to prevent a plausible-looking design from being accepted when it has silently weakened, changed, omitted, or made unprovable a requirement.

The review is **cyclic**:

```text
AUTHORITATIVE SOURCES
        ↓
Semantic requirements ledger
        ↓
Design / migration plan
        ↓
Critical acceptance review
        ↓
      GREEN? ─────────────── yes ──→ accepted
        │
        no
        ↓
Atomic REWORK packets
        ↓
Constrained revision
        ↓
Full regression review
        ↺
```

A cycle must continue until `GREEN` is reached or execution is explicitly stopped because an authoritative-source ambiguity cannot be resolved without a human decision.

---

# 1. When to use

Use this skill when one or more of the following are true:

- a current system must migrate to a richer target architecture;
- multiple specifications, ADRs, requirements, prototypes, or recovered design artifacts define the target;
- an existing repository is the factual current-state baseline;
- semantic precision matters more than producing a quick architecture answer;
- AI agents will later implement the resulting architecture;
- the design contains safety, data-integrity, security, human-approval, audit, deterministic-output, or reliability invariants;
- a previous design has been revised several times and semantic drift is a risk;
- `GREEN` must mean something stronger than “looks reasonable”.

Do not use this skill merely to generate first-pass architecture ideas. Create the design first, then use this skill to certify it.

---

# 2. Required inputs

The reviewer must identify these inputs before review begins.

## 2.1 Normative target

The authoritative specification of the desired system.

Examples:

- requirements specification;
- architecture specification;
- ADR set;
- accepted design documents;
- product/technical contract;
- recovered artifact chain explicitly designated as target behavior.

The normative target defines what **must eventually be true**.

## 2.2 Current-state evidence

The actual repository and its current authoritative documentation.

Repository evidence outranks assumptions about the current system.

Inspect implementation where a claim materially affects the migration design. Do not infer a capability from filenames, README wording, or an architectural intention if code or persistence constraints contradict it.

## 2.3 Design under review

The architecture, migration plan, phased plan, implementation strategy, or other artifact being accepted.

## 2.4 Optional previously accepted review state

If this is cycle 2 or later, include:

- prior requirements ledger;
- prior `REWORK` findings;
- previously accepted semantics;
- current cycle number;
- prior design revision identifier/hash if available.

---

# 3. Authority precedence

Define precedence explicitly before reviewing.

Default:

```text
1. Normative target specification — desired-state authority.
2. Current repository implementation — factual current-state authority.
3. Current authoritative repository documentation — supporting current-state contract.
4. Design under review — proposal only.
5. Reviewer inference — never authoritative.
```

Do not silently reconcile conflicts.

If the target says `A` and the plan says `B`, the plan is wrong unless `B` is explicitly identified as a permitted design choice and does not violate `A`.

If the plan says the current repository already implements `C`, verify `C` from repository evidence.

If the target is genuinely ambiguous, record `SOURCE_AMBIGUITY` instead of inventing a requirement.

---

# 4. Semantic requirements ledger

Before judging the design, normalize the target into atomic requirements.

This ledger is the semantic checksum for every cycle.

Each requirement should contain:

```text
Requirement ID
Normative statement
MUST / SHOULD / MAY
Source artifact
Source section / location
Interpretation notes
Current-system evidence/status
Criticality
```

Example:

```text
REQ-ALIGN-006
Normative statement:
Global document order must not be a hard alignment invariant.
Local monotonicity may be used only inside an established local region.

Strength: MUST
Source: target architecture §Alignment
Criticality: Critical
Current state: current validator enforces global monotonicity
```

## 4.1 Preserve requirement strength

Do not turn:

- `MUST` into “recommended”, “prefer”, or “where practical”;
- `MUST NOT` into “generally avoid”;
- `SHOULD` into an unconditional hard requirement without identifying the strengthening as a `DESIGN_CHOICE`;
- a local heuristic into a global invariant;
- a global invariant into an implementation suggestion.

## 4.2 Preserve semantic distinctions

Pay particular attention to distinctions such as:

```text
alignment ≠ review ≠ export
proposal state ≠ final disposition
source identity ≠ source text
retrieval representation ≠ authoritative evidence
confidence score ≠ calibrated probability
missing content ≠ intentionally non-runtime content
semantic similarity ≠ structured equality
review-required output ≠ finalized output
checkpoint ≠ idempotency
```

Similar wording is not enough. Review semantic equivalence.

---

# 5. Review dimensions

Every critical requirement must be checked against all relevant dimensions.

## 5.1 Data model

Can the proposed data model represent the requirement without lossy encoding or hidden assumptions?

Check:

- identity;
- cardinality;
- immutable vs mutable state;
- revisioning;
- provenance;
- exact offsets/spans;
- missing/extra/unresolved states;
- relationships and invariants.

A plan does not support `N:1` merely because prose says it does if the database prevents legal target reuse.

## 5.2 Algorithm

Can the proposed algorithm actually produce the required behavior?

Check:

- hard constraints vs soft priors;
- recovery behavior;
- uncertainty;
- no-forced-match behavior;
- candidate generation;
- reranking;
- local/global order assumptions;
- deterministic validation after probabilistic operations.

## 5.3 Persistence

Can state survive retries, restarts, revisions, human changes, and historical inspection?

Check:

- immutable inputs;
- append-only review history;
- version binding;
- last-known-good artifacts;
- checkpoint identity;
- idempotency keys;
- stale-revision protection.

## 5.4 API

Can the API expose and enforce the required lifecycle?

Check:

- create/start behavior;
- asynchronous state;
- review mutations;
- server-side authorization;
- finalization gates;
- retry/cancel semantics;
- immutable historical versions.

## 5.5 UI / review workflow

Can a user see and resolve every state the domain model permits?

Check:

- unresolved items;
- missing/extra content;
- evidence;
- exact spans;
- split/merge/relink;
- approval/lock;
- finalization blockers;
- conflict handling.

A backend-only `REVIEW_REQUIRED` flag does not satisfy a requirement for an in-product review workbench.

## 5.6 Lifecycle and state transitions

Check whether stages can publish an invalid later state prematurely.

Examples:

- `READY_FOR_REVIEW` must not publish before reconciliation if reconciliation is mandatory;
- final artifact must not publish before finalization/preflight;
- retries must not overwrite approved human state;
- cancellation must not result in a false success.

## 5.7 Validation

Check whether deterministic validators prove all mandatory invariants around probabilistic steps.

Examples:

- exact-span validation;
- protected-token validation;
- structured category/value association validation;
- source range validation;
- syntax validation;
- duplicate export identity detection.

## 5.8 Failure behavior

Ask what happens when the system cannot prove correctness.

Preferred safety behavior is often:

```text
unresolved
manual review
blocked finalization
last-known-good retained
```

Never accept a design that must force a match merely to produce output when the target permits `unresolved`.

## 5.9 Provenance and auditability

A critical automated decision should be explainable without rerunning the system.

Check whether provenance includes all relevant versions and inputs, for example:

```text
input revisions/hashes
extractor version
classification version
retrieval/window configuration
embedding provider/model/version
pivot representation/model when applicable
candidate evidence
reranker/scorer version
alignment algorithm version
LLM model
prompt/schema version
resolver invocation ID
validator results/version
review events
exporter version
artifact checksum
security/provider configuration where normative
```

## 5.10 Acceptance-test sufficiency

The test must prove the semantics, not merely execute code.

Weak:

```text
Product X issue is detected.
```

Strong:

```text
Given the same numeric value set assigned to different category labels,
the system emits a category/value mapping discrepancy and must not
classify the section as equivalent merely because the numeric sets match.
```

---

# 6. Verdict rules

Only two overall verdicts are allowed:

```text
GREEN
REWORK
```

Do not use:

- mostly green;
- accepted with comments;
- conditional green;
- partial pass;
- reasonable.

## 6.1 GREEN

`GREEN` is permitted only when all of the following are true:

- every critical requirement is satisfied;
- every critical requirement is traceable to an implementation mechanism;
- every critical requirement is traceable to an acceptance test;
- no semantic contradiction remains;
- no migration phase temporarily violates a critical invariant;
- current-state claims are supported by repository evidence;
- no unresolved critical or high-severity `REWORK` finding remains;
- previously accepted semantics have not regressed;
- required mutation/adversarial cases are rejected correctly;
- all mandatory release gates are preserved at their original normative strength.

One unresolved critical semantic defect means `REWORK`.

## 6.2 REWORK

Return `REWORK` when any of these is true:

- requirement omitted;
- requirement contradicted;
- requirement weakened;
- requirement strengthened without explicit design-choice classification;
- current-system capability misrepresented;
- proposed schema cannot express the behavior;
- algorithm contradicts the requirement;
- sequencing makes a required benchmark/calibration impossible;
- migration temporarily breaks a critical invariant;
- failure behavior can silently produce unsafe output;
- security requirement is absent or deferred beyond the point it is needed;
- provenance is insufficient to explain a final decision;
- acceptance test would pass without proving the requirement;
- previously accepted semantics regressed.

---

# 7. Atomic REWORK packets

Do not respond to a failure with “improve the plan”.

Each finding must be an atomic correction contract.

Use this schema:

```text
ID
Severity: CRITICAL | HIGH | MEDIUM | LOW
Requirement IDs violated
Exact design section
Observed wording/design
Why it is semantically or architecturally incorrect
Required semantic correction
Required acceptance test
Sections/invariants that MUST NOT change as collateral damage
Evidence supporting the finding
```

Example:

```text
AR-017 — CRITICAL

Requirements:
REQ-ALIGN-006
REQ-ALIGN-007

Section:
Phase 3 — Candidate alignment

Observed design:
The plan retains one global forward target cursor and allows occasional
exceptions.

Why incorrect:
The normative target says global order is not an invariant. A forward
cursor with exceptions still makes global monotonicity the base model.

Required correction:
1. Remove global target cursor as an alignment invariant.
2. Introduce region-level anchors.
3. Permit region permutation.
4. Retain monotonicity only inside established regions.

Required acceptance test:
A source region ordering A,B,C must correctly align to target regions C,A,B
without classifying A or B as missing.

Must not change:
- tenant/job vector isolation;
- bounded candidate sets;
- exact-span grounding.
```

---

# 8. Constrained rework

The rework agent receives:

- current plan;
- full requirements ledger;
- all open REWORK packets;
- all previously accepted semantics marked `MUST_NOT_REGRESS`.

Its task is **not** to redesign freely.

It must:

1. correct each REWORK finding;
2. preserve unrelated accepted semantics;
3. add/strengthen acceptance evidence required by the finding;
4. identify any unavoidable collateral change explicitly;
5. produce a new revision rather than overwriting the prior review record.

The reviewer must not assume the rework was correct because the requested text was added. Re-evaluate the complete design.

---

# 9. Full regression review after every cycle

After rework, review the **entire artifact again**.

Do not review only changed sections.

Each cycle must rerun:

```text
1. Full requirements-ledger traceability
2. Semantic-equivalence review
3. Data-model review
4. Algorithm review
5. Persistence/lifecycle review
6. API/UI review
7. Failure/safety review
8. Security review
9. Provenance/audit review
10. Acceptance-test sufficiency review
11. Regression check against previously accepted semantics
12. Adversarial/mutation pass
```

A fix in an alignment phase may invalidate assumptions in review or export. Whole-artifact review prevents local fixes from creating downstream semantic drift.

---

# 10. Semantic mutation testing

For critical requirements, create plausible incorrect interpretations and confirm that the review rejects them.

Example normative requirement:

```text
The LLM selects exact existing target spans.
```

Mutations that MUST cause `REWORK`:

```text
The LLM may lightly normalize selected translation text.

The LLM may synthesize a target string when no candidate is sufficiently good.

Exact target text only needs to be preserved after final approval.
```

Other useful architectural mutations:

```text
MUST → SHOULD
local heuristic → global invariant
unresolved state → forced best match
review approval → LLM confidence threshold
derived retrieval pivot → authoritative evidence
immutable extracted text → reviewer-mutated source record
finalization preflight → post-publication warning
replay checkpoint → assumed idempotency
```

The mutation suite is a test of the **review process itself**.

---

# 11. Adversarial reviewer pass

Before final `GREEN`, perform an adversarial pass whose only objective is to invalidate the candidate `GREEN` verdict.

The adversarial reviewer should ask:

- What requirement was technically mentioned but not implementably supported?
- Which `MUST` became advisory language?
- Which acceptance test can pass while the required semantics are still wrong?
- Is a current repository capability being assumed rather than evidenced?
- Is an immutable record accidentally mutable?
- Is a global/local distinction blurred?
- Can a low-confidence case still be forced through?
- Can a human-approved state be overwritten by retry/reprocessing?
- Can final output be published without every authoritative gate?
- Is a security control introduced after the phase that already needs it?
- Can provenance explain the decision without rerunning AI?

Any new critical/high finding returns the cycle to `REWORK`.

---

# 12. Traceability matrix

Before `GREEN`, produce a matrix with no blank critical rows.

Recommended columns:

| Requirement | Normative source | Current-state evidence | Design phase/component | Implementation mechanism | Acceptance test | Result |
|---|---|---|---|---|---|---|
| REQ-... | target §... | repo path / absent | Phase ... | ... | ... | PASS |

For every critical requirement:

```text
requirement
→ design mechanism
→ implementation location/boundary
→ acceptance test
```

must be visible.

---

# 13. Cycle ledger

Keep a permanent record of each iteration.

Example:

```text
Cycle 1
Verdict: REWORK
Critical/high findings: 16

Cycle 2
Verdict: REWORK
Resolved: all Cycle-1 findings
New full-regression findings: 5
Regressions: none

Cycle 3
Verdict: REWORK
Resolved: Cycle-2 findings
Remaining precision findings: 3

Cycle 4
Verdict: GREEN
Open critical/high findings: 0
Requirement traceability: complete
Adversarial pass: passed
Mandatory mutation cases: passed
```

For each cycle record:

```text
cycle number
design revision/hash
review input revisions
verdict
open findings
resolved findings
new findings
regressions
source ambiguities
adversarial result
```

Never erase earlier REWORK findings. They are evidence of how acceptance was reached.

---

# 14. Execution roles

For stronger independence, separate roles when possible.

```text
Agent A — Semantic Extractor
Normative target → requirements ledger

Agent B — Critical Reviewer
Requirements + repository evidence + design → GREEN/REWORK

Agent C — Rework Agent
Only open REWORK contracts + accepted invariants → revised design

Agent B — Full Reviewer again
Full revised design → GREEN/REWORK

Agent D — Adversarial Reviewer
Candidate GREEN → attempt to invalidate acceptance
```

If one model performs multiple roles, reset the task framing between roles and require explicit source/evidence grounding. Do not let “I wrote this design” become evidence that it is correct.

---

# 15. Canonical critical-review prompt

Use or adapt the following prompt for the review stage.

```text
You are the critical acceptance reviewer for a software architecture.

Your task is NOT to improve the design unless the verdict is REWORK.
Your task is to determine whether the proposed design faithfully,
completely and implementably reaches the normative target semantics.

AUTHORITATIVE INPUT PRECEDENCE

1. Normative target specification — desired-state authority.
2. Current repository implementation — factual current-state authority.
3. Current authoritative repository documentation — supporting evidence.
4. Design under review — proposal only.

You must not silently reconcile conflicts.

SEMANTIC RULES

- Preserve MUST, SHOULD and MAY distinctions.
- Do not weaken a target requirement.
- Do not strengthen a requirement unless explicitly classified DESIGN_CHOICE.
- Do not infer that the current repository implements a feature without evidence.
- Similar wording is not sufficient; check semantic equivalence.
- Distinguish global invariants from local heuristics.
- Distinguish alignment, review, and export where applicable.
- Treat missing/extra/unresolved as legitimate states where the target does.
- Do not accept a design that can force an answer merely because output is required.
- Probabilistic output must remain grounded in immutable evidence where the target requires it.
- Final publication must follow the target's deterministic authority rules.

REVIEW EVERY REQUIREMENT AGAINST

1. Data model
2. Algorithm
3. Persistence
4. API
5. UI/review workflow
6. Lifecycle/state transitions
7. Validation
8. Failure behavior
9. Security
10. Provenance/auditability
11. Acceptance tests

VERDICT

Return exactly one overall verdict:

GREEN
or
REWORK

GREEN is permitted only when:
- every critical requirement is satisfied;
- every critical requirement has an implementation mechanism;
- every critical requirement has an acceptance test sufficient to prove it;
- no semantic contradiction remains;
- no migration phase temporarily violates a critical invariant;
- current-state claims are repository-evidenced;
- there are no regressions from previously accepted requirements;
- the adversarial/mutation pass finds no critical/high defect.

If REWORK, produce atomic findings.

For each finding provide:

ID
Severity
Requirement IDs violated
Exact design section
Observed wording/design
Why it is semantically or architecturally incorrect
Required semantic correction
Required acceptance test
Sections/invariants that MUST NOT change as collateral damage
Supporting evidence

After rework, review the ENTIRE design again, not only modified sections.

Never issue GREEN because a design is generally reasonable.
GREEN means critically accepted against the normative target.
```

---

# 16. Rework-agent prompt

```text
You are the constrained architecture rework agent.

Inputs:
- normative requirements ledger;
- current design revision;
- open REWORK packets;
- previously accepted semantics marked MUST_NOT_REGRESS.

Your task is to correct every open REWORK packet without freely redesigning
unrelated accepted architecture.

For every REWORK packet:
1. apply the required semantic correction;
2. add or strengthen the required acceptance test;
3. preserve every listed MUST_NOT_CHANGE invariant;
4. report any unavoidable collateral effect explicitly.

Do not mark findings resolved yourself.
Only the critical reviewer may issue GREEN.

Produce a new design revision and a change log mapping each REWORK ID to
its corrected section.
```

---

# 17. Stop conditions

Continue cycling automatically while:

- verdict is `REWORK`;
- findings are actionable from available sources;
- rework does not require a missing human product decision.

Stop without `GREEN` only when:

```text
SOURCE_AMBIGUITY
AUTHORITATIVE_CONFLICT
MISSING_REQUIRED_SOURCE
HUMAN_POLICY_DECISION_REQUIRED
```

In that case, report the exact blocked requirement and decision needed.

Do not fabricate a target semantic merely to finish the cycle.

---

# 18. Required outputs

A complete architecture-cycle run should produce at least:

```text
REQUIREMENTS_LEDGER.md
ARCHITECTURE_REVIEW_CYCLES.md
TRACEABILITY_MATRIX.md
<design>.accepted.md        # only after GREEN
```

Optional but recommended:

```text
SEMANTIC_MUTATION_CASES.md
REWORK_PACKETS/
ADVERSARIAL_REVIEW.md
EVIDENCE_MANIFEST.md
```

The final accepted artifact should identify:

- normative source versions/hashes;
- repository commit/ref used for current-state evidence;
- final design revision/hash;
- cycle count;
- final verdict;
- remaining non-critical design choices or deferred optimizations.

---

# 19. Method proven in the Overlay → TOME002 review

This template is based on the cyclic review method used to validate a phased migration from an existing Overlay application to a richer TOME002 target architecture.

The execution pattern was:

```text
1. Freeze source precedence:
   target specification → normative;
   existing repository → factual current state;
   migration plan → proposal.

2. Review semantics rather than prose similarity.

3. Cycle 1 returned REWORK with 16 atomic critical/high findings.

4. Rework was constrained to those findings while preserving accepted
   architecture such as deterministic export, human authority, exact-span
   grounding, and current safety substrate.

5. The full design was re-reviewed, not only modified sections.

6. Cycle 2 returned REWORK with a smaller set of operational/contract gaps.

7. Cycle 3 returned REWORK with remaining precision defects.

8. A final adversarial pass found one last weak conditional requirement;
   it was corrected before acceptance.

9. Cycle 4 returned GREEN only after the full requirement ledger,
   reliability/security requirements, data-model invariants, mandatory
   regression cases, and hard automation gates each had an implementation
   mechanism and sufficient acceptance evidence.
```

The important lesson is that the number of findings decreasing across cycles is **not** the acceptance criterion.

Acceptance occurred only when:

```text
open critical/high semantic defects = 0
AND
critical requirement traceability = complete
AND
full regression review = pass
AND
adversarial pass = pass
```

This is the defining behavior of the skill.

---

# 20. Completion condition

The architecture-cycle task is complete only when either:

```text
GREEN
```

has been issued under the rules above, or execution has stopped with an explicit authoritative-source/human-decision blocker.

A shrinking REWORK list, a high-quality design, passing implementation tests, or reviewer confidence is not a substitute for `GREEN` semantic acceptance.
