package io.github.shrinkshi.primal.warfare;

import io.github.shrinkshi.primal.core.PrimalModuleIds;
import io.github.shrinkshi.primal.society.PrimalSociety;
import net.neoforged.fml.common.Mod;

/**
 * 小队、指挥、士气、据点、区域控制与战争规则入口。
 */
@Mod(PrimalWarfare.MOD_ID)
public final class PrimalWarfare {
    public static final String MOD_ID = PrimalModuleIds.WARFARE;
    public static final String SOCIETY_DEPENDENCY = PrimalSociety.MOD_ID;

    public PrimalWarfare() {
    }
}
