#!/usr/bin/env python3
# speech_recognition.py - HuggingFace Whisper 语音识别（免费，无需API Key）
# 用法: python speech_recognition.py "<audio_file_path>"

import sys
import json
import urllib.request
import urllib.error
import os

def recognize_speech(audio_path):
    """使用 HuggingFace Inference API 识别语音"""
    
    # 读取音频文件
    with open(audio_path, "rb") as f:
        audio_data = f.read()
    
    # 新的 HuggingFace Router API
    url = "https://router.huggingface.co/hf-inference/models/openai/whisper-large-v3-turbo"
    
    headers = {
        "Content-Type": "audio/ogg"
    }
    
    req = urllib.request.Request(url, data=audio_data, headers=headers, method="POST")
    
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            result = json.loads(resp.read().decode("utf-8"))
            return result
    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8")
        return {"error": f"HTTP {e.code}: {error_body}"}

def main():
    if len(sys.argv) < 2:
        print("用法: python speech_recognition.py \"<音频文件路径>\"")
        sys.exit(1)
    
    audio_path = sys.argv[1]
    
    if not os.path.exists(audio_path):
        print(f"错误: 文件不存在: {audio_path}")
        sys.exit(1)
    
    print("识别语音中...")
    try:
        result = recognize_speech(audio_path)
        
        if "error" in result:
            print(f"识别失败: {result['error']}")
            sys.exit(1)
        
        # HuggingFace 返回格式: {"text": "..."}
        text = result.get("text", "")
        if text:
            print(f"识别结果: {text}")
        else:
            print("识别失败: 未返回文本")
            print(json.dumps(result, ensure_ascii=False, indent=2))
            
    except Exception as e:
        print(f"识别失败: {e}")

if __name__ == "__main__":
    main()
