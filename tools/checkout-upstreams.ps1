param(
    [switch]$NoPull
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$targetRoot = Join-Path $repoRoot 'thirdparty\upstreams'
New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

# 只登记已经确认公开源码仓库与 1.21.1 对应分支的项目。
# Slide! 暂未确认公开源码入口；Millénaire 9 的 Java 源码/再发布许可需要单独确认，因此不自动检出。
$repositories = @(
    @{
        Name = 'epicfight'
        Url = 'https://github.com/Antikythera-Studios/epicfight.git'
        Branch = '1.21.1'
    },
    @{
        Name = 'puffish-skills'
        Url = 'https://github.com/pufmat/skillsmod.git'
        Branch = '1.21'
    },
    @{
        Name = 'stealth-and-alert'
        Url = 'https://github.com/RedGhostRev/Stealth-and-Alert.git'
        Branch = 'main'
    },
    @{
        Name = 'yori3os-grappling-hooks'
        Url = 'https://github.com/yori3o/Yori3osGrapplingHooks.git'
        Branch = '1.21.1'
    }
)

foreach ($entry in $repositories) {
    $path = Join-Path $targetRoot $entry.Name

    if (Test-Path (Join-Path $path '.git')) {
        Write-Host "[Primal] 更新 $($entry.Name)" -ForegroundColor Cyan
        git -C $path fetch --all --tags --prune
        git -C $path checkout $entry.Branch
        if (-not $NoPull) {
            git -C $path pull --ff-only
        }
    }
    elseif (Test-Path $path) {
        throw "目标目录已存在但不是 Git 仓库：$path"
    }
    else {
        Write-Host "[Primal] 克隆 $($entry.Name) ($($entry.Branch))" -ForegroundColor Cyan
        git clone --branch $entry.Branch --single-branch $entry.Url $path
    }
}

Write-Host ''
Write-Host "第三方源码工作副本已准备在：$targetRoot" -ForegroundColor Green
Write-Host '这些目录默认不进入 Primal Git；需要实际魔改时，应先确认许可证并创建/绑定自己的 fork。'
