---
name: baidu-ocr
description: 使用百度OCR API识别图片中的文字，支持中英文混合识别、股票持仓截图、表格等。当用户发送图片或截图需要识别文字时自动使用。
tags: [ocr, image, recognition, baidu, chinese]
---

# Baidu OCR 技能

使用百度智能云OCR API识别图片文字，特别优化中文识别效果。

## 功能

- 通用文字识别（中英文混合）
- 持仓截图识别
- 表格识别
- 身份证/银行卡等证件识别

## 使用方法

当用户发送图片需要识别时，调用百度OCR API：

```bash
# 1. 获取access_token
curl -X POST "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id={API_KEY}&client_secret={SECRET_KEY}"

# 2. 调用OCR
curl -X POST "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic?access_token={ACCESS_TOKEN}" -H "Content-Type:application/x-www-form-urlencoded" --data-urlencode "image={BASE64_IMAGE}"
```

## 配置

需要在 config.json 中配置：
- api_key: 百度AI平台的 API Key
- secret_key: 百度AI平台的 Secret Key

## 获取凭据

1. 访问 https://console.bce.baidu.com/ai/#/ai/ocr/overview/index
2. 创建应用获取 API Key 和 Secret Key
