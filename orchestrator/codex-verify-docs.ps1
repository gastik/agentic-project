param(
    [Parameter(Mandatory=$true)]
    [string]$AgentFile,
    [Parameter(Mandatory=$false)]
    [string]$TargetProject = $PWD
)

$CodexBin = "C:\Users\asgas\.codex\packages\standalone\releases\0.147.0-x86_64-pc-windows-msvc\bin\codex.exe"

if (-not (Test-Path $AgentFile)) {
    Write-Error "Agent file not found: $AgentFile"
    exit 1
}

$agentPrompt = Get-Content -Raw -Path $AgentFile

$fullPrompt = @"
You are executing a documentation review/verification agent.

AGENT INSTRUCTIONS:
$agentPrompt

RULES:
1. Verify the documentation against the required criteria.
2. Do not modify files. Output your verification report or feedback directly.
"@

Write-Host "Running Codex Doc Reviewer: $(Split-Path $AgentFile -Leaf)"
$fullPrompt | & $CodexBin exec --approve-for-me --cd $TargetProject -

if ($LASTEXITCODE -ne 0) {
    Write-Error "Codex verification failed with exit code $LASTEXITCODE."
    exit $LASTEXITCODE
}
Write-Host "Review/Verification completed."
