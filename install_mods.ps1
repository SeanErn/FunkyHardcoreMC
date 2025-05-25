# PowerShell script to add Modrinth mods to packwiz
# Tracks successful and failed installations

# Define the list of mods to install
$mods = @(
    "bad packets",
    "BCLib",
    "Better Statistics Screen",
    "BetterEnd",
    "BetterF3",
    "BetterNether",
    "Boss Music Mod/Datapack",
    "Chunky",
    "CICADA",
    "Cloth Config API",
    "Concurrent Chunk Management Engine (Fabric)",
    "Continuity",
    "CraftPresence",
    "Debugify",
    "Distant Horizons",
    "Do a Barrel Roll",
    "Fabric API",
    "Fabric Language Kotlin",
    "Farmer's Delight Refabricated",
    "FerriteCore",
    "Indium",
    "Iris Shaders",
    "Krypton",
    "Lithium",
    "Mod Menu",
    "Music Delay Reducer",
    "Music Notification",
    "Nature's Compass",
    "Pumpkin Pie Delight",
    "qrafty's Jungle Villages",
    "qrafty's Mangrove Villages",
    "Sodium",
    "Sodium Extra",
    "TCDCommons API",
    "Terralith",
    "Text Placeholder API",
    "https://modrinth.com/mod/textile_backup",
    "UniLib",
    "World Weaver",
    "WTHIT",
    "WunderLib",
    "Xaero's Minimap",
    "Xaero's World Map",
    "YetAnotherConfigLib (YACL)"
)

# Arrays to track results
$successfulMods = @()
$failedMods = @()

# Check if packwiz.exe exists
if (!(Test-Path ".\packwiz.exe")) {
    Write-Host "ERROR: packwiz.exe not found in current directory!" -ForegroundColor Red
    Write-Host "Please ensure packwiz.exe is in the same directory as this script." -ForegroundColor Yellow
    exit 1
}

Write-Host "Starting mod installation process..." -ForegroundColor Green
Write-Host "Total mods to install: $($mods.Count)" -ForegroundColor Cyan
Write-Host "=" * 50

$counter = 0

foreach ($mod in $mods) {
    $counter++
    Write-Host "[$counter/$($mods.Count)] Processing: $mod" -ForegroundColor Yellow
    
    try {
        # Run packwiz command
        $arguments = @("modrinth", "add", $mod)
        $process = Start-Process -FilePath ".\packwiz.exe" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host "✓ Successfully added: $mod" -ForegroundColor Green
            $successfulMods += $mod
        } else {
            Write-Host "✗ Failed to add: $mod (Exit code: $($process.ExitCode))" -ForegroundColor Red
            $failedMods += $mod
        }
    }
    catch {
        Write-Host "✗ Error processing: $mod - $($_.Exception.Message)" -ForegroundColor Red
        $failedMods += $mod
    }
}

Write-Host ""
Write-Host "=" * 50
Write-Host "INSTALLATION SUMMARY" -ForegroundColor Cyan
Write-Host "=" * 50

Write-Host "Successfully installed: $($successfulMods.Count) mods" -ForegroundColor Green
if ($successfulMods.Count -gt 0) {
    foreach ($mod in $successfulMods) {
        Write-Host "  ✓ $mod" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Failed installations: $($failedMods.Count) mods" -ForegroundColor Red
if ($failedMods.Count -gt 0) {
    Write-Host "FAILED CANDIDATES:" -ForegroundColor Red
    Write-Host "-----------------" -ForegroundColor Red
    foreach ($mod in $failedMods) {
        Write-Host "  ✗ $mod" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Common reasons for failure:" -ForegroundColor Yellow
    Write-Host "- Mod name doesn't match Modrinth project name exactly" -ForegroundColor Yellow
    Write-Host "- Mod is not available on Modrinth" -ForegroundColor Yellow
    Write-Host "- Network connectivity issues" -ForegroundColor Yellow
    Write-Host "- Mod requires different Minecraft version" -ForegroundColor Yellow
} else {
    Write-Host "🎉 All mods installed successfully!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation process completed!" -ForegroundColor Cyan