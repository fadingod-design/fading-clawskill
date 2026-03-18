# 百度语音识别 Skill

## 功能
将语音文件（ogg/mp3/wav/pcm）转换为文字

## 使用方法
```
python speech_recognition.py "<音频文件路径>"
```

## 配置步骤
1. 访问 https://console.bce.baidu.com/ai/#/ai/speech/overview/index
2. 创建应用，获取 API Key 和 Secret Key
3. 填入 `config.json`:
```json
{
  "api_key": "你的API_KEY",
  "secret_key": "你的SECRET_KEY"
}
```

## 支持格式
- ogg（飞书语音格式）
- mp3
- wav
- pcm

## 费用
百度语音识别有免费额度，足够日常使用。
