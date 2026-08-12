# Planning-to-Development Integration

The development pipeline accepts only tasks that passed the planning readiness gate.

A coding agent receives one coding task, the Repository Capability Contract, relevant repository state, and referenced architecture/contracts.

If a coding agent finds the task impossible, contradictory, or dependent on an unresolved architecture/product decision, it must stop scope expansion, record evidence, mark the task BLOCKED, and return the issue to planning. It must not silently redesign the task.
