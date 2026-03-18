# Skill 创建器

## 功能
自动化创建新 skill 并同步到 GitHub

## 工作流程
1. 创建 skill 目录结构
2. 生成 SKILL.md（使用说明）
3. 生成脚本文件
4. 更新 MEMORY.md
5. 自动上传到 GitHub

## 目录结构
```
workspace/.agents/skills/{skill-name}/
├── SKILL.md          # 必需：使用说明
├── {skill-name}.ps1  # PowerShell 脚本
├── {skill-name}.py   # Python 脚本（可选）
└── config.json       # 配置文件（可选）
```

## 使用方法
```powershell
.\create_skill.ps1 -Name "skill名称" -Description "功能描述" -ScriptType "ps1"
```

## 自动规则
- 每生成一个新 skill，自动调用 github-sync 上传
- Token 从 config.json 读取，不写入代码
