# generate_word.ps1 - 生成 Word 文档
# 用法: .\generate_word.ps1 -OutputPath "输出路径" -Title "标题" -Sections @{标题1=@("内容1","内容2")}

param(
    [Parameter(Mandatory=$true)]
    [string]$OutputPath,
    
    [string]$Title = "文档标题",
    
    [hashtable]$Sections
)

try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $doc = $word.Documents.Add()
    $selection = $word.Selection
    
    # 主标题
    $selection.Style = "标题"
    $selection.TypeText($Title)
    $selection.TypeParagraph()
    $selection.ParagraphFormat.Alignment = 1  # 居中
    
    # 各节内容
    foreach ($sectionTitle in $Sections.Keys) {
        $selection.Style = "标题 1"
        $selection.TypeText($sectionTitle)
        $selection.TypeParagraph()
        
        $contents = $Sections[$sectionTitle]
        if ($contents -is [array]) {
            foreach ($content in $contents) {
                $selection.Style = "列表段落"
                $selection.TypeText($content)
                $selection.TypeParagraph()
            }
        }
        else {
            $selection.Style = "正文"
            $selection.TypeText($contents)
            $selection.TypeParagraph()
        }
    }
    
    # 保存文档
    $doc.SaveAs([ref]$OutputPath)
    $doc.Close()
    
    Write-Host "Word 文档已生成: $OutputPath"
}
catch {
    Write-Host "生成失败: $_"
}
finally {
    $word.Quit()
}
