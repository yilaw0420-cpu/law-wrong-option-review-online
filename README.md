# 法考错选复习线上版

这是可以直接部署到 Vercel 或 Cloudflare Pages 的静态版本。

- 数据主存储：Supabase `wrong_questions`
- 默认共享组：`couple-law-review`
- OCR：随项目部署的 `vendor/tesseract`
- 配置文件：`config.js`
- 数据库与 RLS：`supabase-schema.sql`
- 部署步骤：`DEPLOY.md`

部署前先填写 `config.js`，然后部署整个 `law-wrong-option-review-online` 文件夹。Output Directory 使用 `.`。
