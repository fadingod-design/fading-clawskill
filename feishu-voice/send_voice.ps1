# send_voice.ps1 - 飞书语音发送
# 用法: .\send_voice.ps1 -Text "你好" [-UserId "ou_xxx"]

param(
    [Parameter(Mandatory=$true)]
    [string]$Text,
    
    [string]$UserId
)

# 生成语音文件
$outputPath = "$PSScriptRoot\temp\voice.wav"
$tempDir = Split-Path $outputPath -Parent

if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
}

Write-Host "生成语音: $Text"

Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.SetOutputToWaveFile($outputPath)
$synth.Speak($Text)
$synth.Dispose()

if (Test-Path $outputPath) {
    $fileSize = (Get-Item $outputPath).Length
    Write-Host "语音文件已生成: $outputPath"
    Write-Host "文件大小: $fileSize bytes"
    
    if ($UserId) {
        Write-Host ""
        Write-Host "发送到飞书用户: $UserId"
        Write-Host "使用 message 工具发送此文件"
    }
    
    Write-Host ""
    Write-Host "文件路径: $outputPath"
} else {
    Write-Host "错误: 文件生成失败"
}
