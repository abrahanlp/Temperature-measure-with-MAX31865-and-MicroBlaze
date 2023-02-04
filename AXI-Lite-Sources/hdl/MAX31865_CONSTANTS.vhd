----------------------------------------------------------------------------------
-- This code is release under CERN Open Hardware Licence Version 2 - Strongly Reciprocal
-- You can read license details in: https://ohwr.org/cern_ohl_s_v2.txt
-- Company: FaultyProject
-- Engineer: Abraham Lemos Perez
-- 
-- Create Date: 10.10.2022 22:08:08
-- Module Name: STATE_CONSTANTS - Behavioral
-- Target Devices: FPGA
-- Tool Versions: Vivado 2020.2
-- Description: State Machine Constants for MAX31865_driver.vhd
--              MAX31865 Addresses
-- 
-- Dependencies: No
-- 
-- Revision:
-- Revision 0.01 - File Created, first release
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

package MAX31865_CONSTANTS is
    constant SCLK_F: integer := 5000000;
    constant STATE_BITS: integer := 4;
    constant S_CONFIG: unsigned(STATE_BITS-1 downto 0) := "0000";
    constant S_HIGH_MSB_THRESHOLD: unsigned(STATE_BITS-1 downto 0) := "0001";
    constant S_HIGH_LSB_THRESHOLD: unsigned(STATE_BITS-1 downto 0) := "0010";
    constant S_LOW_MSB_THRESHOLD: unsigned(STATE_BITS-1 downto 0) := "0011";
    constant S_LOW_LSB_THRESHOLD: unsigned(STATE_BITS-1 downto 0) := "0100";
    constant S_BIAS_ON: unsigned(STATE_BITS-1 downto 0) := "0101";
    constant S_WAIT_1: unsigned(STATE_BITS-1 downto 0) := "0110";
    constant S_1_SHOT: unsigned(STATE_BITS-1 downto 0) := "0111";
    constant S_WAIT_2: unsigned(STATE_BITS-1 downto 0) := "1000";
    constant S_READ_H_W: unsigned(STATE_BITS-1 downto 0) := "1001";
    constant S_READ_H_R: unsigned(STATE_BITS-1 downto 0) := "1010";
    constant S_READ_L_W: unsigned(STATE_BITS-1 downto 0) := "1011";
    constant S_READ_L_R: unsigned(STATE_BITS-1 downto 0) := "1100";
    constant S_BIAS_OFF: unsigned(STATE_BITS-1 downto 0) := "1101";
    constant S_WAIT_3: unsigned(STATE_BITS-1 downto 0) := "1110";
    
    constant WR_SPI: unsigned(STATE_BITS-1 downto 0) := "1111";
    
    constant ADD_RTD_MSB: std_logic_vector(7 downto 0) := X"01";
    constant ADD_RTD_LSB: std_logic_vector(7 downto 0) := X"02";
    constant ADD_CONFIG: std_logic_vector(7 downto 0) := X"80";
    constant ADD_HIGH_MSB_THRESHOLD: std_logic_vector(7 downto 0) := X"83";
    constant ADD_HIGH_LSB_THRESHOLD: std_logic_vector(7 downto 0) := X"84";
    constant ADD_LOW_MSB_THRESHOLD: std_logic_vector(7 downto 0) := X"85";
    constant ADD_LOW_LSB_THRESHOLD: std_logic_vector(7 downto 0) := X"86";
end package;
