# create_skill.ps1 - 创建新 skill 并上传到 GitHub
# 用法: .\create_skill.ps1 -Name "skill名称" -Description "功能描述"

param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    
    [string]$Description = "待补充",
    
    [ValidateSet("ps1", "py", "both")]
    [string]$ScriptType = "ps1"
)

$skillsDir = "C:\Users\不安\.openclaw-autoclaw\workspace\.agents\skills"
$skillPath = Join-Path $skillsDir $Name

# 检查是否已存在
if (Test-Path $skillPath) {
    Write-Host "警告: Skill 已存在 - $Name"
    Write-Host "路径: $skillPath"
    exit 1
}

# 创建目录
New-Item -ItemType Directory -Path $skillPath -Force | Out-Null
Write-Host "✓ 创建目录: $skillPath"

# 生成 SKILL.md
$skillMd = @"
# $Name

## 功能
$Description

## 使用方法
``````
.\$Name.ps1
``````

## 配置
如需配置，请编辑 config.json

## 注意事项
- 自动生成于: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

Set-Content -Path (Join-Path $skillPath "SKILL.md") -Value $skillMd -Encoding UTF8
Write-Host "✓ 创建 SKILL.md"

# 生成脚本文件
if ($ScriptType -eq "ps1" -or $ScriptType -eq "both") {
    $scriptContent = @"
# $Name.ps1 - $Description
# 用法: .\$Name.ps1

param(
    [string]`$Param1
)

Write-Host "Running $Name..."
# TODO: 实现功能
"@
    Set-Content -Path (Join-Path $skillPath "$Name.ps1") -Value $scriptContent -Encoding UTF8
    Write-Host "✓ 创建 $Name.ps1"
}

if ($ScriptType -eq "py" -or $ScriptType -eq "both") {
    $pyContent = @"
#!/usr/bin/env python3
# $Name.py - $Description
# 用法: python $Name.py

import sys

def main():
    print("Running $Name...")
    # TODO: 实现功能

if __name__ == "__main__":
    main()
"@
    Set-Content -Path (Join-Path $skillPath "$Name.py") -Value $pyContent -Encoding UTF8
    Write-Host "✓ 创建 $Name.py"
}

# 更新 MEMORY.md
$memoryPath = "C:\Users\不安\.openclaw-autoclaw\workspace\MEMORY.md"
$memoryContent = Get-Content $memoryPath -Raw

# 检查是否已有技能索引
if ($memoryContent -match "## 技能索引") {
    # 添加到现有索引
    $newSkillEntry = "- **$Name**: $Description"
    $memoryContent = $memoryContent -replace "(## 技能索引\r?\n)", "`$1$newSkillEntry`n"
} else {
    # 创建技能索引
    $skillIndex = @"

## 技能索引
- **$Name**: $Description
"@
    $memoryContent = $memoryContent + $skillIndex
}

Set-Content -Path $memoryPath -Value $memoryContent -Encoding UTF8 -NoNewline
Write-Host "✓ 更新 MEMORY.md"

# 上传到 GitHub
Write-Host "`n上传到 GitHub..."
& "C:\Users\不安\.openclaw-autoclaw\workspace\.agents\skills\github-sync\sync_to_github.ps1" -SkillName $Name

Write-Host "`n✓ Skill 创建完成: $Name"
