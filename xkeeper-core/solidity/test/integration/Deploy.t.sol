// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {CommonIntegrationTest} from '../integration/Common.t.sol';

contract IntegrationDeploy is CommonIntegrationTest {
  function test_automationVaultParams() public {
    assertEq(automationVault.owner(), owner);
  }
}
