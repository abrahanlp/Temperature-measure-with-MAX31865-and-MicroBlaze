----------------------------------------------------------------------------------
-- This code is release under CERN Open Hardware Licence Version 2 - Strongly Reciprocal
-- You can read license details in: https://ohwr.org/cern_ohl_s_v2.txt
-- Company: FaultyProject
-- Engineer: Abraham Lemos Perez
-- 
-- Create Date: 04.10.2022 20:58:57
-- Module Name: MAX31865_driver_t - Behavioral
-- Target Devices: MAX31865_driver.vhd
-- Tool Versions: Vivado 2020.2
-- Description: MAX31865_driver.vhd Behavioral Simulation
-- 
-- Dependencies: MAX31865_CONSTANTS.vhd
--				 MAX31865_driver.vhd
--               serial_interface.vhd
--
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAX31865_driver_t is
    
end MAX31865_driver_t;

architecture Behavioral of MAX31865_driver_t is
    constant PERIODO  : time  := 200 ns;
    signal cs_n_t     : std_logic;
    signal sclk_t     : std_logic;
    signal mosi_t     : std_logic;
    signal miso_t     : std_logic := '0';
    signal drdy_n_t   : std_logic := '1';
        
    signal reset_n_t  : std_logic := '0';
    signal clk_t      : std_logic := '0';
    signal rtd_val_t      : std_logic_vector(15 downto 0);
        
    component MAX31865_driver is
    Port ( cs_n     : out std_logic; --Señales de control MAX31865
           sclk     : out std_logic;
           mosi     : out std_logic;
           miso     : in  std_logic;
           drdy_n   : in  std_logic;
   
           reset_n  : in  std_logic; --Señales de control Driver
           clk_spi  : in  std_logic;
           rtd_val  : out STD_LOGIC_VECTOR (15 downto 0));
    end component MAX31865_driver;
    
begin
    UUT : MAX31865_driver port map ( cs_n_t, sclk_t, mosi_t, miso_t, drdy_n_t,
                                      reset_n_t, clk_t, rtd_val_t);
    
    reset_n_t <= '1', '0' after (PERIODO/4), '1' after (PERIODO+PERIODO/4);
    clk_t <= not clk_t after (PERIODO/2);

    vector_test: process
    begin
        drdy_n_t <= '1'; wait for (146*PERIODO);
        drdy_n_t <= '0'; wait for (14*PERIODO + PERIODO/2);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (13*PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        drdy_n_t <= '1'; wait for (52*PERIODO);
        drdy_n_t <= '0'; wait for (15*PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (13*PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
        miso_t <= '1'; wait for (PERIODO);
        miso_t <= '0'; wait for (PERIODO);
    end process vector_test;
end Behavioral;
