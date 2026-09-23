[README.md](https://github.com/user-attachments/files/32555932/README.md)
# DSH Launcher · 一键启停

在 Windows 上双击即可启动 / 停止 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 的网页界面，**无需打开终端、无需手动输入命令**。

把「打开终端 → 输入命令 → 等待启动 → 手动打开浏览器」这一整套流程，压缩成一次双击。

## ✨ 功能特性

- **双击即用**：一个文件搞定启动，零命令、零终端。
- **静默后台运行**：服务在后台启动，不会弹出黑乎乎的终端窗口。
- **自动打开浏览器**：等服务就绪后，自动打开 `http://127.0.0.1:3080`。
- **自动判断运行状态**：如果服务已经在运行，就只打开浏览器，不会重复启动。
- **一键停止**：精准结束占用 `3080` 端口的进程，不误杀其它 Node 程序。
- **多级启动回退**：依次尝试全局 `dsh` 命令 → 直接调用 `node` → `npx`，尽量兼容不同安装方式。
- **完全自适应**：自动探测 Node、npm、npx 与 DeepSeek Harness 的安装位置，**无需手动修改任何路径**。

## 📁 文件说明

| 文件 | 作用 |
|------|------|
| `启动 DeepSeek Harness.vbs` | 一键启动（核心文件） |
| `停止 DeepSeek Harness.vbs` | 一键停止 |

> 脚本内容为纯 ASCII（界面提示为英文），因此 GitHub 可直接正常高亮显示；下载到 Windows 后双击即可使用，中文不会乱码。

## 🖥 使用环境

- Windows 8 及以上
- 已安装 [Node.js](https://nodejs.org/)（自带 npm / npx）
- 已安装 DeepSeek Harness（`@deepseek-ai/dsh`）

## 🚀 使用方法

1. 把两个 `.vbs` 文件放到任意位置（推荐桌面）。
2. 双击 **`启动 DeepSeek Harness.vbs`**，等待片刻，浏览器会自动打开 `http://127.0.0.1:3080`。
3. 想停止时，双击 **`停止 DeepSeek Harness.vbs`**。

> 💡 首次双击时，如果 Windows 弹出「打开文件 - 安全警告」，点击「运行」即可（这是系统对 VBS 脚本的常规提示，属正常现象）。

## 🔧 工作原理

启动器按以下流程运行：

1. 检测 `http://127.0.0.1:3080` 是否已有响应；
2. 若无响应，则在后台（隐藏窗口）启动 DeepSeek Harness 的 web 服务；
3. 轮询等待服务就绪（最长约 45 秒）；
4. 自动打开系统默认浏览器。

启动方式按以下顺序回退（全部自动探测，无需修改）：

1. 全局命令 `dsh web`（通过 `npm install -g @deepseek-ai/dsh` 安装后可用）
2. 直接调用 `node` 运行 `@deepseek-ai/dsh` 的 `bin.js`（从 npx 缓存自动定位）
3. `npx --yes @deepseek-ai/dsh web`

停止器通过 PowerShell 找到监听 `3080` 端口的进程并结束它，因此**只影响 DeepSeek Harness，不会误杀其它 Node 程序**。

## ⚙️ 修改端口

如果 DeepSeek Harness 不是跑在默认的 `3080` 端口：

- **启动器**：修改文件开头的 `Const URL = "http://127.0.0.1:3080"`
- **停止器**：修改文件开头的 `Const PORT = "3080"`
## 这是第一次上传在这里上传文件。只是个新手。如有建议请告知我。如果觉得还行请点个星星再走吧
## 全程用deepseek-v4开发
## 📄 许可证

MIT
