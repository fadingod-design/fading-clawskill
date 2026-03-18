# 邮件发送 Skill

## 功能
生成 Word 文档并通过 QQ 邮箱发送

## 使用方法
```
python send_email.py "<收件人邮箱>" "<邮件主题>" "<邮件正文>" "<附件路径>"
```

## 配置
发件人信息已记录在 MEMORY.md：
- 邮箱: 1784350294@qq.com
- SMTP: smtp.qq.com:587
- 授权码: spctbhqjdwhadfef

## 示例
```powershell
# 发送带 Word 附件的邮件
$from = "1784350294@qq.com"
$to = "recipient@example.com"
$password = "spctbhqjdwhadfef"

$message = New-Object System.Net.Mail.MailMessage
$message.From = $from
$message.To.Add($to)
$message.Subject = "邮件主题"
$message.Body = "邮件正文"
$message.Attachments.Add("C:\path\to\file.docx")

$smtp = New-Object System.Net.Mail.SmtpClient("smtp.qq.com", 587)
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($from, $password)
$smtp.Send($message)
```

## 注意事项
- QQ 邮箱需要使用授权码，不是密码
- 支持 SSL/TLS 加密
- 端口: 587 (推荐) 或 465
