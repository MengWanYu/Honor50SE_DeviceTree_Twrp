# GitHub Actions Workflow Trigger Script
# Automatically triggers the recovery build workflow after fixes

# Read token from environment variable
$Token = $env:GITHUB_TOKEN
if (-not $Token) {
    Write-Host "Error: GITHUB_TOKEN environment variable not set" -ForegroundColor Red
    Write-Host "Usage: `$env:GITHUB_TOKEN = 'your_token'; .\trigger_workflow.ps1" -ForegroundColor Yellow
    exit 1
}

$Owner = "MengWanYu"
$Repo = "Honor50SE_DeviceTree_Twrp"
$Workflow = "main.yml"
$Branch = "main"

$Url = "https://api.github.com/repos/$Owner/$Repo/actions/workflows/$Workflow/dispatches"
$Body = @{
    ref = $Branch
} | ConvertTo-Json

Write-Host "Triggering GitHub Actions workflow..." -ForegroundColor Green
Write-Host "Repository: $Owner/$Repo" -ForegroundColor Cyan
Write-Host "Workflow: $Workflow" -ForegroundColor Cyan
Write-Host "Branch: $Branch" -ForegroundColor Cyan
Write-Host ""

try {
    $Response = Invoke-WebRequest -Uri $Url -Method Post -Headers @{
        Authorization = "token $Token"
        Accept = "application/vnd.github.v3+json"
    } -Body $Body -ContentType "application/json"

    Write-Host "✓ Workflow triggered successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "View workflow at: https://github.com/$Owner/$Repo/actions" -ForegroundColor Yellow
} catch {
    Write-Host "✗ Failed to trigger workflow" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}