# GitHub Skill 同步

## 功能
将新生成的 skill 自动上传到 GitHub 仓库

## 使用方法
```
.\sync_to_github.ps1 -SkillName "skill名称"
```

## 自动规则
- 每生成一个新 skill 后，自动调用此脚本上传
- GitHub 仓库: https://github.com/fadingod-design/fading-clawskill

## 配置
- Token 已存储在 MEMORY.md
- 本地 skills 目录: `workspace/.agents/skills/`
