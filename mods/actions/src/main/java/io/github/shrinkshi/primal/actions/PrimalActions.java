package io.github.shrinkshi.primal.actions;

import io.github.shrinkshi.primal.core.PrimalModuleIds;
import io.github.shrinkshi.primal.progression.PrimalProgression;
import net.neoforged.fml.common.Mod;

/**
 * 动作、潜行处决与第三方战斗/移动模组兼容入口。
 */
@Mod(PrimalActions.MOD_ID)
public final class PrimalActions {
    public static final String MOD_ID = PrimalModuleIds.ACTIONS;

    // 显式引用 progression，确保本模块的编译依赖关系在工作区骨架阶段即可被验证。
    public static final String PROGRESSION_DEPENDENCY = PrimalProgression.MOD_ID;

    public PrimalActions() {
    }
}
