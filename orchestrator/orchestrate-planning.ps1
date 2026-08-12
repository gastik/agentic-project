param(
    [string]$FrameworkRoot = "C:\projects\agentic-project",
    [Parameter(Mandatory=$true)]
    [string]$TargetProject,
    [switch]$Clean
)

$CodexBin = "C:\Users\asgas\.codex\packages\standalone\releases\0.147.0-x86_64-pc-windows-msvc\bin\codex.exe"

Write-Host "Verifying Codex authentication..."
& $CodexBin whoami *>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Codex authentication failed. Please run 'codex login --device-auth' first."
    exit 1
}

if ($Clean) {
    Write-Host "Cleaning generated artifacts in Target Project..."
    if (Test-Path "$TargetProject\planning\tasks") {
        Get-ChildItem -Path "$TargetProject\planning\tasks" -File | Remove-Item -Force
    }
    if (Test-Path "$TargetProject\planning\output") {
        Get-ChildItem -Path "$TargetProject\planning\output" -File | Where-Object { $_.Name -ne 'idea.md' } | Remove-Item -Force
    }
    if (Test-Path "$TargetProject\planning\EVIDENCE_MANIFEST.md") {
        Remove-Item -Force "$TargetProject\planning\EVIDENCE_MANIFEST.md"
    }
}

$agents = Get-ChildItem -Path "$FrameworkRoot\planning\agents" -Filter "*.md" | Sort-Object Name
$ideaFile = "$TargetProject\planning\output\idea.md"

foreach ($agent in $agents) {
    Write-Host "=========================================="
    Write-Host "Running Codex for: $($agent.Name)"
    Write-Host "=========================================="
    
    $promptFile = $agent.FullName
    $prompt = Get-Content -Raw -Path $promptFile
    $idea = Get-Content -Raw -Path $ideaFile
    
    if ($agent.Name -eq "08b-task-generator.md") {
        # Parse the task IDs from the generated dependency graph
        $graphContent = Get-Content -Path "$TargetProject\planning\output\TASK_DEPENDENCY_GRAPH.md"
        $tasks = @()
        foreach ($line in $graphContent) {
            if ($line -match "\| (T-\d+) .*?\|") {
                $tasks += $matches[1]
            }
        }
        $tasks = $tasks | Select-Object -Unique

        foreach ($taskId in $tasks) {
            Write-Host "--- Generating Codex task for: $taskId ---"
            $fullPrompt = @"
You are executing the planning phase agent: 08b-task-generator.md.
Read the instructions below and apply them to the project Idea.
All output must be written to planning/tasks/ as specified in your prompt.

IDEA CONTEXT:
$idea

TASK TO GENERATE:
$taskId

AGENT INSTRUCTIONS:
$prompt
"@
            # Call codex CLI non-interactively via stdin
            $fullPrompt | & $CodexBin exec --approve-for-me --cd $TargetProject -
            
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Codex failed on $($agent.Name) for task $taskId with exit code $LASTEXITCODE."
                exit $LASTEXITCODE
            }
        }
    } else {
        # We pass the instruction to codex via its prompt argument
        # We instruct Codex to read the idea and the schema, and write to the output folder.
        $fullPrompt = @"
You are executing the planning phase agent: $($agent.Name).
Read the instructions below and apply them to the project Idea.
All output must be written to planning/output/ or planning/tasks/ as specified in your prompt.

IDEA CONTEXT:
$idea

AGENT INSTRUCTIONS:
$prompt
"@

        # Call codex CLI non-interactively via stdin
        $fullPrompt | & $CodexBin exec --approve-for-me --cd $TargetProject -
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Codex failed on $($agent.Name) with exit code $LASTEXITCODE."
            exit $LASTEXITCODE
        }
    }
}

Write-Host "Pipeline execution completed successfully."
