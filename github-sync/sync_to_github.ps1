# sync_to_github.ps1 - 同步 skill 到 GitHub
# 用法: .\sync_to_github.ps1 -SkillName "skill名称"

param(
    [Parameter(Mandatory=$true)]
    [string]$SkillName
)

# 从配置文件读取
$configPath = Join-Path $PSScriptRoot "config.json"
$config = Get-Content $configPath | ConvertFrom-Json
$token = $config.token
$repo = $config.repo

$repoUrl = "https://$token@github.com/$repo.git"
$cloneDir = "C:\Users\不安\.openclaw-autoclaw\workspace\temp\fading-clawskill"
$sourceSkills = "C:\Users\不安\.openclaw-autoclaw\workspace\.agents\skills"
$skillPath = "$sourceSkills\$SkillName"

# 检查 skill 是否存在
if (-not (Test-Path $skillPath)) {
    Write-Host "错误: Skill 不存在 - $SkillName"
    exit 1
}

# 拉取最新代码
cd $cloneDir
git pull origin main 2>&1 | Out-Null

# 复制 skill
$destPath = "$cloneDir\skills\$SkillName"
Copy-Item $skillPath -Destination $destPath -Recurse -Force
Write-Host "已复制: $SkillName"

# 更新 README
$skillsDir = "$cloneDir\skills"
$skillFolders = Get-ChildItem $skillsDir -Directory

$skillList = $skillFolders | ForEach-Object {
    $name = $_.Name
    $skillMd = Join-Path $_.FullName "SKILL.md"
    $desc = "待补充"
    if (Test-Path $skillMd) {
        $content = Get-Content $skillMd -Raw
        if ($content -match "## 功能\s*\n+(.+?)(?=\n##|$)") {
            $desc = $Matches[1].Trim()
        }
    }
    "### $name`n$desc"
}

$readme = @"
# Fading ClawSkill

AutoClaw 技能仓库，由市场操作员自动维护。

## 技能列表

$($skillList -join "`n`n")

---
自动同步于: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

Set-Content -Path "$cloneDir\README.md" -Value $readme -Encoding UTF8

# 提交并推送
git add .
git commit -m "Update skill: $SkillName" 2>&1 | Out-Null
git push origin main 2>&1

Write-Host "`n✓ $SkillName 已上传到 GitHub"
Write-Host "仓库地址: https://github.com/$repo"
