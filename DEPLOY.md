# 法考错选复习线上部署说明

## 1. 先配置 Supabase

1. 打开 Supabase 项目的 SQL Editor。
2. 运行项目根目录的 `supabase-schema.sql`。
3. 在 Supabase 控制台打开 `Project Settings` -> `API`。
4. 找到 Project URL 和 anon/public key。
5. 打开 `config.js`，填写：

```js
window.LAW_REVIEW_CONFIG = {
  supabaseUrl: "https://你的项目.supabase.co",
  supabaseAnonKey: "你的 anon public key",
  groupId: "couple-law-review",
  tableName: "wrong_questions",
};
```

不要把 service_role key 填进网页。anon public key 本来就是前端公开密钥，数据权限由 RLS policy 控制。

## 2. 应该部署哪个文件夹

部署整个：

```text
law-wrong-option-review-online
```

不要只上传 `index.html`，因为 OCR 还需要：

```text
vendor/tesseract/
```

项目是纯静态网站，不需要 Python、Node.js 后端、数据库文件或构建步骤。

## 3. 部署到 Vercel

### 网页上传或 Git 导入

1. 在 Vercel 新建 Project。
2. 选择包含 `law-wrong-option-review-online` 的 Git 仓库，或使用 Vercel CLI 部署该文件夹。
3. 如果仓库根目录不是线上版目录，将 Root Directory 设为：

```text
law-wrong-option-review-online
```

4. Framework Preset 选 `Other`。
5. Build Command 留空。
6. Install Command 留空。
7. Output Directory 填：

```text
.
```

8. 点击 Deploy。

使用 Vercel CLI 时，在该目录执行：

```bash
vercel
```

之后生产部署可执行：

```bash
vercel --prod
```

## 4. 部署到 Cloudflare Pages

### Direct Upload

1. 打开 Cloudflare Dashboard -> Workers & Pages。
2. 新建 Pages 项目并选择 Direct Upload。
3. 上传整个 `law-wrong-option-review-online` 文件夹，或上传解压后的完整目录内容。
4. 发布即可。

### Git 集成

1. 连接包含本项目的 Git 仓库。
2. Root Directory 设为：

```text
law-wrong-option-review-online
```

3. Framework preset 选 `None`。
4. Build command 留空。
5. Build output directory 填：

```text
.
```

6. 保存并部署。

## 5. 部署后检查

打开公网地址后检查：

1. 页面能正常显示，没有空白页。
2. 录入并保存一道测试题。
3. 刷新页面后题目仍存在。
4. 用另一台设备打开同一网址，能看到同一道题。
5. 点击“看过”“掌握”“取消掌握”“编辑”“删除”，刷新后状态仍正确。
6. 上传截图后 OCR 能加载，浏览器开发者工具中没有 `vendor/tesseract` 的 404。
7. `config.js`、`vendor/tesseract/worker.min.js`、语言模型和 `.wasm` 文件都能从同一站点加载。

## 6. 路径和安全说明

- 所有项目资源都使用相对路径，例如 `./config.js` 和 `./vendor/tesseract/...`。
- Vercel 和 Cloudflare Pages 都会提供 HTTPS，窗口截取功能需要 HTTPS 才能正常申请权限。
- 页面不使用 service_role key。
- RLS 只允许 anon 角色访问 `group_id = 'couple-law-review'` 的记录。
- 由于当前没有登录系统，知道公网网址的人仍可能使用这个共享组。建议不要公开传播网址。
- 截图保存在 `image_data` 字段中。尽量先框选题目区域，避免上传过大的整屏图片。
