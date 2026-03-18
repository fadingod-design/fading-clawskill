# 飞书语音发送 Skill

## 功能
将文字转换为语音并发送到飞书

## 使用方法
```
python send_voice.py "<文字内容>" "<飞书用户ID>"
```

## 技术实现
1. 使用 Windows 内置语音合成 (System.Speech)
2. 生成 wav 格式语音文件
3. 通过飞书消息接口发送

## 示例
```powershell
# PowerShell 调用
Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.SetOutputToWaveFile("voice.wav")
$synth.Speak("你好，我是市场操作员")
$synth.Dispose()
```

## 注意事项
- 仅支持 Windows 系统
- 飞书不支持音频链接播放，必须发送本地文件
- 使用 `message` 工具发送，不能用 Markdown
