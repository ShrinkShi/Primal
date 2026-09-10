# Primal

Primal 是一个面向 Minecraft 1.21.1 + NeoForge 的大型整合包 / 多 Mod 开发工作区。

项目目标不是把所有玩法塞进一个巨型 Mod，而是用多个职责清晰的 Primal 模组承载整合包独有规则，再通过 API、数据包和兼容层接入 Epic Fight、Millénaire 等第三方生态。

## 当前技术基线

- Minecraft：1.21.1
- NeoForge：21.1.250
- Java：21
- ModDevGradle：2.0.146
- Gradle：9.2.1
- IDE：IntelliJ IDEA（根目录作为一个 Gradle Project 导入）
- 仓库形态：Monorepo，多 Mod、多个独立 JAR、统一开发运行环境

版本号与依赖基线集中在 `gradle.properties` 和 `gradle/primal-thirdparty.gradle`。

## 自研模块

| Gradle 模块 | Mod ID | 职责 |
| --- | --- | --- |
| `mods:core` | `primal_core` | 公共 API、事件、标识、基础协议 |
| `mods:progression` | `primal_progression` | 等级、技能、天赋与技能框架适配 |
| `mods:actions` | `primal_actions` | 动作、潜行处决、战斗/移动兼容 |
| `mods:society` | `primal_society` | 部落、阵营、职位、声望、外交 |
| `mods:settlement` | `primal_settlement` | 聚落、族人、职业与村庄系统整合 |
| `mods:warfare` | `primal_warfare` | 小队、RTS 指挥、士气、据点、战争 |

依赖方向必须保持单向，禁止通过互相 `implementation project(...)` 形成循环。

## 克隆后用 IDEA 打开

1. 安装 JDK 21。
2. `git clone https://github.com/ShrinkShi/Primal.git`
3. 在 IDEA 中直接打开仓库根目录，不要分别打开 `mods/*`。
4. 确认 Gradle JVM 为 Java 21，并让 IDEA 按 `settings.gradle` 导入整个项目。
5. 首次同步会下载 NeoForge、Minecraft 映射和第三方开发依赖，属于正常现象。
6. IDEA 生成的主要运行配置：
   - `Primal - Client`
   - `Primal - Dedicated Server`
   - `Primal - GameTest Server`
   - `Primal - Data Generation`

命令行也可以使用：

```bash
./gradlew verifyExternalMods
./gradlew syncClientHelperMods
./gradlew buildAll
./gradlew runClient
./gradlew runServer
./gradlew collectModJars
```

Windows 使用对应的 `gradlew.bat`。

`Primal - Client` / `runClient` 会自动把已锁定的 JEI、Jade、Just Enough Characters、Mouse Tweaks、Inventory Profiles Next、Xaero 小地图/世界地图及其必要前置同步到 `run/client/mods`。这些客户端辅助模组不是 Primal Java 源码的编译依赖。

## 第三方核心玩法模组

当前统一 Dev Runtime 已锁定：

- Epic Fight
- Pufferfish's Skills
- Stealth & Alert
- playerAnimator
- Slide!
- Yori3o's Grappling Hooks
- YetAnotherConfigLib (YACL)
- Millénaire

其中 `primal_progression`、`primal_actions`、`primal_settlement` 只获得各自真正需要的编译期 API 视图，避免第三方依赖向其他 Primal 模块扩散。

版本、文件 ID、前置关系和许可证注意事项见 `docs/DEPENDENCIES.md`。

## 第三方源码原则

第三方项目默认不把源码复制进 Primal Git 历史：

1. 优先配置；
2. 再使用数据包 / 资源包 / CraftTweaker；
3. 再使用官方 API；
4. 再写 Primal Addon / Compat；
5. 缺少 Hook 时优先向上游提交 PR；
6. 最后才维护 Fork / Mixin Patch。

需要阅读或修改已经确认公开源码的上游项目时，可执行：

```powershell
.\tools\checkout-upstreams.ps1
```

源码会检出到 Git 忽略的 `thirdparty/upstreams/`，可在本地 IDEA 中查看或作为额外 Gradle 项目链接。真正形成长期修改后，应建立自己的 fork 并保留清晰的 upstream 关系，而不是把第三方源码直接提交到 Primal Monorepo。

## 目录

```text
Primal/
├─ mods/                 # 六个自研 NeoForge Mod
├─ pack/                 # 整合包配置、数据包、资源包、脚本与自定义内容
├─ thirdparty/           # 第三方说明；upstreams/ 为本地源码工作副本且 Git 忽略
├─ tools/                # 工作区辅助脚本
├─ docs/                 # GDD/TDD/ADR/验收文档
├─ run/                  # 本地开发运行目录（Git 忽略）
├─ build.gradle
├─ settings.gradle
└─ gradle.properties
```

详细说明见 `docs/WORKSPACE.md`、`docs/ARCHITECTURE.md` 和 `docs/DEPENDENCIES.md`。
