param(
    [Parameter(Mandatory=$true)]
    [string]$AgentFile,
    
    [Parameter(Mandatory=$true)]
    [string]$PlanFile,
    [Parameter(Mandatory=$false)]
    [string]$TargetProject = $PWD
)

$CodexBin = "C:\Users\asgas\.codex\packages\standalone\releases\0.147.0-x86_64-pc-windows-msvc\bin\codex.exe"

if (-not (Test-Path $AgentFile)) {
    Write-Error "Agent file not found: $AgentFile"
    exit 1
}

if (-not (Test-Path $PlanFile)) {
    Write-Error "Plan file not found: $PlanFile"
    exit 1
}

$agentPrompt = Get-Content -Raw -Path $AgentFile
$plan = Get-Content -Raw -Path $PlanFile

$fullPrompt = @"
You are executing a documentation specialist agent.

DOCUMENTATION PLAN:
$plan

AGENT INSTRUCTIONS:
$agentPrompt

RULES:
1. You may only create or modify documentation and markdown artifacts.
2. Under no circumstances are you allowed to generate product source code.
"@

Write-Host "Running Codex Doc Writer for: $(Split-Path $AgentFile -Leaf)"
$fullPrompt | & $CodexBin exec --sandbox workspace-write --approve-for-me --cd $TargetProject -

if ($LASTEXITCODE -ne 0) {
    Write-Error "Codex execution failed with exit code $LASTEXITCODE."
    exit $LASTEXITCODE
}
Write-Host "Documentation phase completed."
