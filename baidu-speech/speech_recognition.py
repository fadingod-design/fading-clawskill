#!/usr/bin/env python3
# speech_recognition.py - 百度语音识别
# 用法: python speech_recognition.py "<audio_file_path>"

import sys
import json
import urllib.request
import urllib.parse
import base64
import os

# 配置文件路径
CONFIG_PATH = os.path.join(os.path.dirname(__file__), "config.json")

def load_config():
    """加载配置"""
    if os.path.exists(CONFIG_PATH):
        with open(CONFIG_PATH, "r", encoding="utf-8") as f:
            return json.load(f)
    return {"api_key": "", "secret_key": ""}

def get_access_token(api_key, secret_key):
    """获取百度 Access Token"""
    url = "https://aip.baidubce.com/oauth/2.0/token"
    params = {
        "grant_type": "client_credentials",
        "client_id": api_key,
        "client_secret": secret_key
    }
    url = f"{url}?{urllib.parse.urlencode(params)}"
    
    with urllib.request.urlopen(url, timeout=30) as resp:
        result = json.loads(resp.read().decode("utf-8"))
        return result.get("access_token")

def recognize_speech(audio_path, access_token):
    """识别语音"""
    # 读取音频文件
    with open(audio_path, "rb") as f:
        audio_data = f.read()
    
    # Base64 编码
    audio_base64 = base64.b64encode(audio_data).decode("utf-8")
    
    # 调用百度语音识别 API
    url = f"https://vop.baidu.com/server_api?access_token={access_token}"
    
    # 检测音频格式
    audio_format = "ogg"
    if audio_path.endswith(".mp3"):
        audio_format = "mp3"
    elif audio_path.endswith(".wav"):
        audio_format = "wav"
    elif audio_path.endswith(".pcm"):
        audio_format = "pcm"
    
    payload = json.dumps({
        "format": audio_format,
        "rate": 16000,
        "channel": 1,
        "speech": audio_base64,
        "len": len(audio_data)
    }).encode("utf-8")
    
    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
    }
    
    req = urllib.request.Request(url, data=payload, headers=headers, method="POST")
    
    with urllib.request.urlopen(req, timeout=60) as resp:
        result = json.loads(resp.read().decode("utf-8"))
        return result

def main():
    if len(sys.argv) < 2:
        print("用法: python speech_recognition.py \"<audio_file_path>\"")
        sys.exit(1)
    
    audio_path = sys.argv[1]
    
    if not os.path.exists(audio_path):
        print(f"错误: 文件不存在: {audio_path}")
        sys.exit(1)
    
    config = load_config()
    
    if not config.get("api_key") or not config.get("secret_key"):
        print("错误: 请先配置百度 API Key")
        print("1. 访问 https://console.bce.baidu.com/ai/#/ai/speech/overview/index")
        print("2. 创建应用，获取 API Key 和 Secret Key")
        print(f"3. 填入 {CONFIG_PATH}")
        sys.exit(1)
    
    print("获取 Access Token...")
    access_token = get_access_token(config["api_key"], config["secret_key"])
    
    if not access_token:
        print("错误: 获取 Access Token 失败")
        sys.exit(1)
    
    print("识别语音中...")
    result = recognize_speech(audio_path, access_token)
    
    if result.get("err_no") == 0:
        text = result.get("result", [""])[0]
        print(f"识别结果: {text}")
    else:
        print(f"识别失败: {result.get('err_msg', '未知错误')}")
        print(json.dumps(result, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
