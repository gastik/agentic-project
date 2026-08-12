param(
    [Parameter(Mandatory=$true)]
    [string]$AgentFile,
    
    [Parameter(Mandatory=$true)]
    [string]$ContextFile,
    [Parameter(Mandatory=$false)]
    [string]$TargetProject = $PWD
)

$CodexBin = "C:\Users\asgas\.codex\packages\standalone\releases\0.147.0-x86_64-pc-windows-msvc\bin\codex.exe"

if (-not (Test-Path $AgentFile)) {
    Write-Error "Agent file not found: $AgentFile"
    exit 1
}

if (-not (Test-Path $ContextFile)) {
    Write-Error "Context file not found: $ContextFile"
    exit 1
}

$agentPrompt = Get-Content -Raw -Path $AgentFile
$context = Get-Content -Raw -Path $ContextFile

$fullPrompt = @"
You are executing a Codex agent.

CONTEXT:
$context

AGENT INSTRUCTIONS:
$agentPrompt
"@

Write-Host "Running Codex agent: $(Split-Path $AgentFile -Leaf)"
$fullPrompt | & $CodexBin exec --approve-for-me --cd $TargetProject -

if ($LASTEXITCODE -ne 0) {
    Write-Error "Codex execution failed with exit code $LASTEXITCODE."
    exit $LASTEXITCODE
}
Write-Host "Execution completed successfully."
