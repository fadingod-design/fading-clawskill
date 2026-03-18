# send_email.ps1 - 发送邮件
# 用法: .\send_email.ps1 -To "收件人邮箱" -Subject "主题" -Body "正文" [-Attachment "附件路径"]

param(
    [Parameter(Mandatory=$true)]
    [string]$To,
    
    [Parameter(Mandatory=$true)]
    [string]$Subject,
    
    [Parameter(Mandatory=$true)]
    [string]$Body,
    
    [string]$Attachment
)

# 发件人配置
$from = "1784350294@qq.com"
$password = "spctbhqjdwhadfef"
$smtpServer = "smtp.qq.com"
$smtpPort = 587

# 创建邮件
$message = New-Object System.Net.Mail.MailMessage
$message.From = $from
$message.To.Add($To)
$message.Subject = $Subject
$message.Body = $Body

# 添加附件
if ($Attachment -and (Test-Path $Attachment)) {
    $message.Attachments.Add($Attachment)
    Write-Host "附件已添加: $Attachment"
}

# 发送邮件
try {
    $smtp = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($from, $password)
    $smtp.Send($message)
    
    Write-Host "邮件发送成功！"
    Write-Host "收件人: $To"
}
catch {
    Write-Host "邮件发送失败: $_"
}
finally {
    $smtp.Dispose()
    $message.Dispose()
}
