// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;

import {SushiXSwapV2} from "../src/SushiXSwapV2.sol";
import {StargateAdapter} from "../src/adapters/StargateAdapter.sol";
import {IRouteProcessor} from "../src/interfaces/IRouteProcessor.sol";
import {IWETH} from "../src/interfaces/IWETH.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../utils/BaseTest.sol";
import "../utils/RouteProcessorHelper.sol";
import {StdUtils} from "forge-std/StdUtils.sol"

import {console2} from "forge-std/console2.sol";

contract SushiXSwapBaseTest is BaseTest {
 SushiXSwapV2 public sushiXswap;
 StargateAdapter public stargateAdapter;
 IRouteProcessor public routeProcessor;
 RouteProcessorHelper public routeProcessorHelper;

    IWETH public weth;
    ERC20 public sushi;
  ERC20 public usdc;

    address constant NATIVE_ADDRESS =
0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public operator = address(0xbeef);
 address public owner = address(0x420);
 address public user = address(0x4201);

    function setUp() public override {
 forkMainnet();
        super.setUp();

        weth = IWETH(constants.getAddress("mainnet.weth"));
 sushi = ERC20(constants.getAddress("mainnet.sushi"));
        usdc = ERC20(constants.getAddress("mainnet.usdc"));
 usdt = ERC20(constants.getAddress("mainnet.usdt"));

        vm.deal(address(operator), 100 ether);
 deal(address(weth), address(operator), 100 ether);
  deal(address(usdc), address(operator), 1 ether);
  deal(address(sushi), address(operator), 1000 ether);

        routeProcessor = IRouteProcessor(
    constants.getAddress("mainnet.routeProcessor")
        );
routeProcessorHelper = new RouteProcessorHelper(
            constants.getAddress("mainnet.v2Factory"),
 constants.getAddress("mainnet.v3Factory"),
 address(routeProcessor),
            address(weth)
   );

        // add operator as privileged
        vm.startPrank(owner);
 sushiXswap = new SushiXSwapV2(routeProcessor, address(weth));

        // add operator as privileged
        sushiXswap.setPrivileged(operator, true);

        // setup stargate adapter
        stargateAdapter = new StargateAdapter(
 constants.getAddress("mainnet.stargateRouter"),
 constants.getAddress("mainnet.stargateWidget"),
 constants.getAddress("mainnet.sgeth"),
