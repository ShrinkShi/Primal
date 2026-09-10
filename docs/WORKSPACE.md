# IDEA / Gradle 工作区说明

## 目标

仓库根目录是唯一应当导入 IDEA 的 Gradle Project。六个自研 Mod 是 Gradle 子项目，各自输出独立 JAR；根项目只承担统一开发运行与聚合构建。

## 为什么使用这种结构

单 Mod 工作区只需要验证一个 JAR。Primal 需要同时处理：

- 多个自研 Mod 的 API 依赖；
- 第三方 Mod 的编译期 API；
- 整包完整客户端；
- Dedicated Server；
- 数据生成；
- 多人服务端权威逻辑。

因此根项目负责把全部本地 Mod SourceSet 装载到同一个 NeoForge Dev Runtime。

## IDEA 验收

克隆后直接打开根目录，等待 Gradle Sync 完成。

应当在 IDEA/Gradle 中看到：

- 根项目 `Primal`
- `:mods:core`
- `:mods:progression`
- `:mods:actions`
- `:mods:society`
- `:mods:settlement`
- `:mods:warfare`

执行 `buildAll` 应产生六个 Mod JAR。

执行 `collectModJars` 后，全部主 JAR 会集中到：

`build/mods/`

执行根项目 `runClient` 时，应一次装载六个 Primal Mod，而不是要求六个 IDEA 窗口分别运行。

## Dedicated Server

多人是设计目标，因此服务端不是事后兼容项。

开发过程中应持续运行：

`gradlew.bat runServer`

首次启动会要求接受 Minecraft EULA。请只在自己的本地开发环境中修改 `run/server/eula.txt`。

客户端专用类以后必须隔离，禁止在 common/server 初始化路径直接引用 `net.minecraft.client.*`。

## Gradle Wrapper

仓库使用标准 Gradle Wrapper，当前版本为 Gradle 9.2.1。

`gradlew`、`gradlew.bat` 与 `gradle/wrapper/gradle-wrapper.jar` 均来自 NeoForge 官方 `MDK-1.21.1-ModDevGradle` 模板，初始化时固定参考提交：

`30cafee9cd8d7f46427ec88fa8579d49c146df9a`

Wrapper JAR 已正常纳入版本管理；CI 的 `gradle/actions/setup-gradle` 会同时执行 Wrapper 校验。

## 第三方依赖

核心玩法依赖集中在 `gradle/primal-thirdparty.gradle`，并进入根项目统一 Dev Runtime。只有实际调用第三方 API 的 Primal 子模组获得对应 `compileOnly` 视图，避免依赖扩散。

当前核心 Runtime 包含 Epic Fight、Pufferfish's Skills、Stealth & Alert、playerAnimator、Yori3o's Grappling Hooks、YACL 和 Millénaire。Slide! 的锁定 JAR 经实物检查为 Fabric-only，已移除；Primal 不引入 Sinytra Connector / Forgified Fabric API，滑铲改由 `primal_actions` 后续原生实现。

客户端 QoL 依赖由 `syncClientHelperMods` 同步到 `run/client/mods`，不进入 Primal Java 编译依赖，也不会出现在 Dedicated Server Dev Runtime。

除了 `verifyExternalMods` 的坐标解析校验，还必须运行 `verifyExternalModLoaders`。该任务直接打开实际下载 JAR，检查 NeoForge/Forge/Fabric metadata，并拒绝 Fabric-only 或未显式白名单的未知 Loader JAR。
