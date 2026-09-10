package io.github.shrinkshi.primal.core;

import net.neoforged.fml.common.Mod;

/**
 * Primal 系列模组的最小公共核心。
 *
 * <p>禁止把战斗、聚落、战争等业务实现塞进此模块。</p>
 */
@Mod(PrimalCore.MOD_ID)
public final class PrimalCore {
    public static final String MOD_ID = PrimalModuleIds.CORE;

    public PrimalCore() {
    }
}
