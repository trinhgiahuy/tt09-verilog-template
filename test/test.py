# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior after reset")

    # Set the input values you want to test
    # dut.ui_in.value = 20
    # dut.uio_in.value = 30

    # Test case 1: Simple input to MAR
    dut.ui_in.value = 0b00001010  # d_in = 1010, select = 00
    dut.uio_in.value = 0b00000101  # g = 1, g1 = 0, g2 = 0 (enable MAR)
    await ClockCycles(dut.clk, 2)

    # Check the output after 2 clock cycles
    dut._log.info(f"uo_out: {dut.uo_out.value}")
    assert dut.uo_out.value == 0b1010, f"Expected 0b1010, got {dut.uo_out.value}"

    # Test case 2: Changing inputs
    dut.ui_in.value = 0b00101111  # d_in = 1111, select = 01
    dut.uio_in.value = 0b00000011  # g = 0, g1 = 0, g2 = 1 (disable MAR)
    await ClockCycles(dut.clk, 2)

    # Check the output after disabling the MAR
    dut._log.info(f"uo_out: {dut.uo_out.value}")
    assert dut.uo_out.value == 0b1010, f"Expected 0b1010, got {dut.uo_out.value}"

    dut._log.info("End of test")
    
    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    # assert dut.uo_out.value == 50

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
