#!/usr/bin/env python3
# send_voice.py - 飞书语音发送
# 用法: python send_voice.py "<文字内容>" [用户ID]

import sys
import os
import subprocess
import json

def generate_voice(text, output_path):
    """使用 PowerShell 语音合成生成语音文件"""
    ps_script = f'''
Add-Type -AssemblyName System.Speech
$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$synth.SetOutputToWaveFile("{output_path}")
$synth.Speak("{text}")
$synth.Dispose()
'''
    result = subprocess.run(
        ["powershell", "-Command", ps_script],
        capture_output=True,
        text=True
    )
    return result.returncode == 0

def main():
    if len(sys.argv) < 2:
        print("用法: python send_voice.py \"<文字内容>\" [用户ID]")
        sys.exit(1)
    
    text = sys.argv[1]
    user_id = sys.argv[2] if len(sys.argv) >= 3 else None
    
    # 生成语音文件
    output_dir = os.path.join(os.path.dirname(__file__), "temp")
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, "voice.wav")
    
    print(f"生成语音: {text}")
    
    if generate_voice(text, output_path):
        if os.path.exists(output_path):
            file_size = os.path.getsize(output_path)
            print(f"语音文件已生成: {output_path}")
            print(f"文件大小: {file_size} bytes")
            
            if user_id:
                print(f"\n发送到飞书用户: {user_id}")
                print("请使用 message 工具发送此文件")
            
            print(f"\n文件路径: {output_path}")
        else:
            print("错误: 文件生成失败")
    else:
        print("错误: 语音合成失败")

if __name__ == "__main__":
    main()
