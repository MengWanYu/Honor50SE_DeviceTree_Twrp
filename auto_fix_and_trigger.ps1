# Automated Fix and Workflow Trigger Script
# Use this script to apply fixes and automatically trigger GitHub Actions workflow

param(
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage
)

# Check if GITHUB_TOKEN is set
if (-not $env:GITHUB_TOKEN) {
    Write-Host "Error: GITHUB_TOKEN environment variable not set" -ForegroundColor Red
    Write-Host "Usage: `$env:GITHUB_TOKEN = 'your_token'; .\auto_fix_and_trigger.ps1 -CommitMessage 'Your message'" -ForegroundColor Yellow
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Auto Fix and Workflow Trigger" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Stage all changes
Write-Host "Step 1: Staging changes..." -ForegroundColor Yellow
git add -A
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to stage changes" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Changes staged" -ForegroundColor Green
Write-Host ""

# Step 2: Commit changes
Write-Host "Step 2: Committing changes..." -ForegroundColor Yellow
git commit -m $CommitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to commit changes" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Changes committed" -ForegroundColor Green
Write-Host ""

# Step 3: Push to GitHub
Write-Host "Step 3: Pushing to GitHub..." -ForegroundColor Yellow
git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to push to GitHub" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Pushed to GitHub" -ForegroundColor Green
Write-Host ""

# Step 4: Trigger workflow
Write-Host "Step 4: Triggering GitHub Actions workflow..." -ForegroundColor Yellow
& .\trigger_workflow.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to trigger workflow" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "All steps completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "View workflow at: https://github.com/MengWanYu/Honor50SE_DeviceTree_Twrp/actions" -ForegroundColor Yellow
Write-Host ""