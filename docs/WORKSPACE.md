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

仓库使用 Gradle 9.2.1。Wrapper JAR 来源固定到 NeoForge 官方 1.21.1 ModDevGradle MDK 的特定提交。

正常仓库中应存在：

`gradle/wrapper/gradle-wrapper.jar`

`gradlew` 和 `gradlew.bat` 还保留了缺失时的安全回退下载逻辑，防止二进制文件意外丢失。

## 第三方依赖

当前提交故意没有把 Epic Fight、Millénaire、技能树、滑铲和钩索模组直接锁进运行时。

原因不是放弃这些方案，而是依赖版本、许可证、API 可用性必须先分别验证。未经兼容矩阵确认就把大型模组写进基础 Gradle 会把“工作区是否正确”与“第三方是否兼容”两个问题混在一起。

第三方接入将在单独阶段逐个落地。
