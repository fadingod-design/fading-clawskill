# Word 文档生成 Skill

## 功能
使用 Windows Word COM 自动生成 Word 文档

## 使用方法
```
.\generate_word.ps1 -Title "标题" -Content "内容" -OutputPath "输出路径"
```

## 技术实现
使用 PowerShell 调用 Word COM 对象：
- `Word.Application` - Word 应用
- `Documents.Add()` - 新建文档
- `Selection.Style` - 设置样式
- `Selection.TypeText()` - 写入文本
- `Document.SaveAs()` - 保存文档

## 示例
```powershell
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$doc = $word.Documents.Add()

$selection = $word.Selection
$selection.Style = "标题"
$selection.TypeText("文档标题")
$selection.TypeParagraph()

$selection.Style = "正文"
$selection.TypeText("文档内容")

$doc.SaveAs([ref]"C:\path\to\output.docx")
$doc.Close()
$word.Quit()
```

## 支持的样式
- 标题
- 标题 1, 标题 2, 标题 3
- 正文
- 列表段落

## 注意事项
- 需要安装 Microsoft Word
- Word 应用会在后台运行，记得调用 `$word.Quit()` 释放资源
