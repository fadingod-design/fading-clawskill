# Whisper 语音识别 Skill（HuggingFace 免费版）

## 功能
使用 HuggingFace Inference API 调用 Whisper 模型识别语音

**完全免费，无需 API Key！**

## 使用方法
```
python speech_recognition.py "<音频文件路径>"
```

## 支持格式
- ogg（飞书语音格式）
- mp3
- wav
- m4a
- webm
- flac

## 模型
使用 `openai/whisper-large-v3-turbo`

## 注意事项
- 首次调用可能需要等待模型加载（约 20 秒）
- 无需注册，无需 API Key
- 支持中文识别
