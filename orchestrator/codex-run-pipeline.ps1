param(
    [Parameter(Mandatory=$true)]
    [string]$AgentsDir,
    
    [Parameter(Mandatory=$true)]
    [string]$ContextFile,
    [Parameter(Mandatory=$false)]
    [string]$TargetProject = $PWD
)

$CodexBin = "C:\Users\asgas\.codex\packages\standalone\releases\0.147.0-x86_64-pc-windows-msvc\bin\codex.exe"

if (-not (Test-Path $AgentsDir)) {
    Write-Error "Agents directory not found: $AgentsDir"
    exit 1
}
if (-not (Test-Path $ContextFile)) {
    Write-Error "Context file not found: $ContextFile"
    exit 1
}

$agents = Get-ChildItem -Path $AgentsDir -Filter "*.md" | Sort-Object Name
$context = Get-Content -Raw -Path $ContextFile

foreach ($agent in $agents) {
    Write-Host "=========================================="
    Write-Host "Running Codex for: $($agent.Name)"
    Write-Host "=========================================="
    
    $prompt = Get-Content -Raw -Path $agent.FullName
    
    $fullPrompt = @"
You are executing pipeline agent: $($agent.Name).
Read the context and apply your instructions.

CONTEXT:
$context

AGENT INSTRUCTIONS:
$prompt
"@

    $fullPrompt | & $CodexBin exec --approve-for-me --cd $TargetProject -
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Codex failed on $($agent.Name) with exit code $LASTEXITCODE."
        exit $LASTEXITCODE
    }
}

Write-Host "Pipeline execution completed successfully."
