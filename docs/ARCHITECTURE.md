# Primal 模组依赖架构

## 原则

一个概念只能有一个 Source of Truth。

例如：

- 玩家所属部落：`primal_society`
- 战争、小队和士气：`primal_warfare`
- 动作状态与处决：`primal_actions`
- 技能/成长规则：`primal_progression`
- 聚落整合：`primal_settlement`
- 跨模块公共标识/API：`primal_core`

禁止多个模块各自保存同一个权威状态。

## 编译依赖

```text
                   primal_core
                  /     |      \
                 /      |       \
    progression       society    \
        |             /    \      \
        |            /      \      \
      actions   settlement  warfare
```

当前依赖：

- progression -> core
- actions -> core + progression
- society -> core
- settlement -> core + society
- warfare -> core + society

`core` 不能反向依赖任何业务模块。

## 第三方接入边界

计划中的第三方职责：

- Epic Fight：动画与战斗运行时
- Stealth & Alert：感知、警觉、搜索、Last Known Position
- Pufferfish/Puffish Skills：技能树框架（最终选型需验证）
- Grappling Hook：钩索物理
- `primal_actions` 原生滑铲：负责 `SPRINT -> SLIDE -> SLIDE_ATTACK -> SLIDE_TAKEDOWN` 状态机、动量、碰撞箱、相机、体力与 Epic Fight 动画衔接
- Millénaire：NPC 文明/村庄模拟基础

原则上，第三方具体类型只允许出现在负责该领域的 Compat 层中。`primal_core` 不得 import Epic Fight、Millénaire 等第三方实现类型。

Slide! 的 1.21.1 锁定发布 JAR 经实物审计为 Fabric-only，因此不再属于 Primal 第三方边界。项目不为该功能引入 Fabric 兼容层，滑铲由 `primal_actions` 自研 NeoForge 原生实现。

## 模块间通信

优先使用：

1. `primal_core` 中稳定的数据类型；
2. NeoForge 事件；
3. 小而明确的服务接口。

避免：

- 模块 A 直接深入修改模块 B 私有状态；
- 通过 Mixin 把 Primal 自己的模块互相粘住；
- 循环 Gradle 依赖。

## Fork 原则

若第三方 Mod 不满足需求：

Config -> Data/Resource Pack -> Script -> API -> Addon -> 上游 PR -> Fork/Mixin。

Fork 必须独立记录 upstream commit、许可证和本地补丁；不能把外部源码随手复制到 `mods/`。
