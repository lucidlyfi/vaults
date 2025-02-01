// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import {IRateProvider} from "../IRateProvider.sol";
import {IERC4626RateProvider} from "./IERC4626RateProvider.sol";
import {ICurvePool} from "../ICurvePool.sol";
import {ISpectraPrincipalToken} from "../ISpectraPrincipalToken.sol";
import {FixedPointMathLib} from "../../../lib/solady/src/utils/FixedPointMathLib.sol";

contract AnglesLiquidVaultRateProvider is IRateProvider {
    error RateProvider__InvalidParam();
    using FixedPointMathLib for uint256;

    uint256 immutable PRECISION = 1e18;

    address immutable WRAPPED_ANGLES_S = 0xfA85Fe5A8F5560e9039C04f2b0a90dE1415aBD70;
    address immutable WRAPPED_S = 0x039e2fB66102314Ce7b64Ce5Ce3E5183bc94aD38;
    address immutable WRAPPED_ANGLES_S_RATE_PROVIDER = 0x2d087C0999223997b77cc33BE5E7E8eC79396cea;
    address immutable SPECTRA_LP_WRAPPED_ANGLES_S = 0xEc81ee88906ED712deA0a17A3Cd8A869eBFA89A0;
    address immutable SPECTRA_LP_WRAPPED_ANGLES_S_POOL = 0x2386ebDE944e723Ffd9066bE23709444342d2685;
    address immutable SPECTRA_PT_WRAPPED_ANGLES_S = 0x032d91C8D301F31025DCeC41008C643e626e80AB;

    /// @dev hardcode price of WRAPPED_S to PRECISION
    function rate(address token) external view returns (uint256) {
        if (token == WRAPPED_S) {
            return PRECISION;
        } else if (token == WRAPPED_ANGLES_S) {
            return IERC4626RateProvider(WRAPPED_ANGLES_S_RATE_PROVIDER).getRate();
        } else if (token == SPECTRA_LP_WRAPPED_ANGLES_S) {
            uint256 lpPrice = ICurvePool(SPECTRA_LP_WRAPPED_ANGLES_S_POOL).price_oracle();
            uint256 ptPrice = ISpectraPrincipalToken(SPECTRA_PT_WRAPPED_ANGLES_S).convertToUnderlying(1e18);
            return lpPrice.mulWad(ptPrice);
        } else {
            revert RateProvider__InvalidParam();
        }
    }
}
