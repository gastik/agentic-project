# 🤖 Guide for Future AI Agents

Hello, future agent! If you are reading this, you are working on the `agentic-project` Framework. We have spent considerable effort refining this pipeline. Please read these critical lessons and architectural decisions before attempting to modify or execute the framework.

## 1. Decoupled Architecture (The Brain vs. The Body)
This repository is the **Framework** (the brain). It contains orchestration scripts, pipeline rules, and LLM agent prompts. 
**CRITICAL RULE:** Do NOT write generated artifacts (e.g., `tasks/`, `output/`) into this repository! 

The framework is designed to run against a **Target Project** (the body). 
When executing the pipeline, always use the `-TargetProject` parameter. For example:
```powershell
.\orchestrator\orchestrate-planning.ps1 -TargetProject "c:\projects\led"
```
The scripts will automatically use `--cd $TargetProject` when invoking Codex, meaning all relative output paths in the agent prompts (like `planning/output/`) will natively resolve to the Target Project's workspace.

## 2. No Code Implementation
This is a Planning and Documentation framework. It generates requirement traceability, architecture impacts, dependency graphs, and bounded coding tasks. It does **not** write product source code. Do not attempt to use `workspace-write` sandboxes to write `.ts`, `.py`, etc. from these pipelines.

## 3. Beating Context Windows (Bulk Generation)
If you need to instruct an agent to generate many large, distinct files (e.g., 22 Coding Tasks), **do not do it in a single prompt.** The LLM will hit output token limits, truncate files, or leave placeholder "TBD" sections.

**The Solution:**
1. Use an upstream agent to generate a conceptual array or graph (e.g., `TASK_DEPENDENCY_GRAPH.md`).
2. Write a loop in PowerShell to parse that graph.
3. Invoke a highly-focused, single-task generator agent (like `08b-task-generator.md`) individually for *each* item via the loop. This guarantees maximum context and focus per file.

## 4. Safely Executing Codex in PowerShell
When writing orchestrator scripts to invoke Codex non-interactively:
- **Avoid Argument Parsing Errors**: Do not pass multi-line prompts via standard CLI arguments. PowerShell will misinterpret spaces. Always pipe the prompt into `stdin` and instruct Codex to read from it using the `-` flag.
- **Bypass the Sandbox Prompt**: Codex will block automated file writes unless you explicitly pass the `--approve-for-me` flag along with the correct `--sandbox` mode.

```powershell
# Example of the correct execution pattern
$fullPrompt | & $CodexBin exec --sandbox workspace-write --approve-for-me --cd $TargetProject -
```

## 5. Handling Pipeline Failures
If the pipeline fails mid-execution (e.g., an agent hallucinates or a gate fails), it is often safer to delete the corrupted output files in the Target Project and execute a clean run. Downstream agents like `apply_patch` will fail if they expect a file to exist with specific content that is no longer there.

---
*By following these guidelines, you will save hours of debugging context limits and PowerShell quoting issues. Good luck!*
