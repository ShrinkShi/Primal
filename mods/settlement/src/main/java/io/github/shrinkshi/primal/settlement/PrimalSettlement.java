package io.github.shrinkshi.primal.settlement;

import io.github.shrinkshi.primal.core.PrimalModuleIds;
import io.github.shrinkshi.primal.society.PrimalSociety;
import net.neoforged.fml.common.Mod;

/**
 * 聚落、族人劳动力与第三方村庄系统的整合入口。
 */
@Mod(PrimalSettlement.MOD_ID)
public final class PrimalSettlement {
    public static final String MOD_ID = PrimalModuleIds.SETTLEMENT;
    public static final String SOCIETY_DEPENDENCY = PrimalSociety.MOD_ID;

    public PrimalSettlement() {
    }
}
