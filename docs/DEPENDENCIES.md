# Primal 第三方模组矩阵

本文档记录 Minecraft 1.21.1 / NeoForge 开发基线中已经锁定的第三方模组。版本坐标由 `gradle/primal-thirdparty.gradle` 作为唯一构建事实来源维护。

## 一、核心玩法基础设施

这些模组进入根项目统一 Dev Runtime。只有确实需要调用其 API 的 Primal 子模组才额外获得 `compileOnly` 依赖。

| 模组 | 锁定版本 | 接入位置 | 当前用途 |
| --- | --- | --- | --- |
| Epic Fight | 21.17.3.1-mc1.21.1-neoforge | `primal_actions` | 战斗与动画运行时、后续处决动作基础 |
| Pufferfish's Skills | 0.19.0-1.21-neoforge | `primal_progression` | 可配置技能树与技能 API |
| Stealth & Alert | 0.1.2-beta.6 | `primal_actions` | 视觉/听觉/警戒/搜索基础 |
| playerAnimator | 2.0.4+1.21.1 | `primal_actions` 支撑库 | Stealth & Alert 当前版本要求 |
| Slide! | 1.0.5+1.21.1 | `primal_actions` | 动量滑铲基础 |
| Yori3o's Grappling Hooks | 5.0.2 | `primal_actions` | 钩索物理与后续附属扩展 |
| YetAnotherConfigLib (YACL) | 3.7.0+1.21.1-neoforge | `primal_actions` 支撑库 | Yori3o's Grappling Hooks 必需前置 |
| Millénaire | 9.0.1 | `primal_settlement` | NPC 村庄、文化、经济和聚落模拟基础 |

### 依赖职责

- `primal_progression`：可以直接编译调用 Pufferfish's Skills API。
- `primal_actions`：可以直接编译调用 Epic Fight、Stealth & Alert、playerAnimator、Slide!、Yori3o's Grappling Hooks 与 YACL 的类/API。
- `primal_settlement`：可以直接编译调用 Millénaire 的公开类；真正绑定内部实现前仍要先确认 9.x 的稳定 API 边界。
- 其他 Primal 模块不会因为“整包里装了这些模组”就自动获得编译依赖，防止依赖扩散。

## 二、客户端辅助模组

这些模组不是 Primal 源码的 Java 依赖。Gradle 仅充当可复现下载器，`syncClientHelperMods` 会把 JAR 实体同步到：

`run/client/mods/`

| 模组 | 锁定版本 | 说明 |
| --- | --- | --- |
| Just Enough Items (JEI) | 19.51.0.418 | 配方/物品浏览 |
| Jade | 15.10.6 | 方块与实体信息 HUD |
| Just Enough Characters | 4.5.23 | JEI 等界面的中文拼音搜索 |
| Mouse Tweaks | 2.26.1 | 背包鼠标操作增强 |
| Inventory Profiles Next | 2.2.5 | 一键整理、库存管理 |
| libIPN | 6.6.3 | Inventory Profiles Next 前置 |
| Kotlin for Forge | 5.12.0 | Inventory Profiles Next 元数据要求的运行前置；显式锁定避免环境差异 |
| Xaero's Minimap | 26.4.2 | 小地图 |
| Xaero's World Map | 1.44.2 | 世界地图 |

执行：

```powershell
.\gradlew.bat syncClientHelperMods
```

即可手动刷新辅助模组。运行 IDEA 的 `Primal - Client` 时也会自动执行该任务。

同步任务只清理由它管理的上述模组旧版本，不会清空整个 `run/client/mods`，因此后续仍可以手工加入其他测试模组。

## 三、第三方源码工作区

发布 JAR 是开发工作区的可复现依赖；源码工作副本只用于阅读、调试、研究或准备 patch。

运行：

```powershell
.\tools\checkout-upstreams.ps1
```

会在以下被 Git 忽略的目录中检出已经确认的公开源码：

`thirdparty/upstreams/`

当前自动检出的仓库：

- Epic Fight：`Antikythera-Studios/epicfight`，`1.21.1` 分支。
- Pufferfish's Skills：`pufmat/skillsmod`，`1.21` 分支。
- Stealth & Alert：`RedGhostRev/Stealth-and-Alert`，`main` 分支。
- Yori3o's Grappling Hooks：`yori3o/Yori3osGrapplingHooks`，`1.21.1` 分支。

Slide! 暂未确认适合作为开发入口的公开源码仓库；Millénaire 9.x 使用 Custom License，且公开 Source 入口与 9.x Java 源码/再发布边界需要继续确认，所以当前不自动克隆，也不假设可以直接 fork 发布。

## 四、许可证原则

“能作为依赖使用”不等于“可以随意修改并重新发布”。在准备 fork、复制源码、复制资源或分发修改版前必须重新检查对应项目许可证。

尤其注意：

- Epic Fight Java 源码为 GPLv3，但其资源许可需要单独遵守，不能把“源码 GPL”理解成所有美术资产均可自由再发布。
- Pufferfish's Skills 与 Millénaire 在发布页面使用自定义许可证，修改/再分发前必须单独核对。
- Xaero 系列属于客户端辅助模组，Primal 仓库只记录下载坐标，不提交其 JAR。

因此 Primal 主仓库默认只保存：依赖坐标、兼容代码、配置、我们自己的内容与用于检出公开上游源码的脚本。

## 五、维护规则

升级任何第三方核心模组时至少检查：

1. Minecraft / NeoForge 版本是否仍为 1.21.1 / 21.1.x。
2. 必需前置是否变化。
3. API/类名是否影响对应 Primal 模块编译。
4. `verifyExternalMods` 是否仍能解析全部锁定 JAR。
5. `Primal - Client` 是否能真实启动并加载全部核心模组与客户端辅助模组。
6. Dedicated Server 是否不会误加载客户端辅助模组。

不要只因为 CurseForge/Modrinth 显示“新版本”就直接升级；整合包以已验证兼容矩阵为准。
