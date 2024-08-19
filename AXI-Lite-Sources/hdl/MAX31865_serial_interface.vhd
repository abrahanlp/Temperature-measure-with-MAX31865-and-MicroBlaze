----------------------------------------------------------------------------------
-- This code is release under CERN Open Hardware Licence Version 2 - Strongly Reciprocal
-- You can read license details in: https://ohwr.org/cern_ohl_s_v2.txt
-- Company: FaultyProject
-- Engineer: Abraham Lemos Perez
-- 
-- Create Date: 18.09.2022 23:34:45
-- Module Name: serial_interface - Behavioral
-- Target Devices: FPGA
-- Tool Versions: Vivado 2020.2
-- Description: Simple SPI VHDL Driver for MAX31865
--              POL = 1;
-- Dependencies: No
-- 
-- Revision:
-- Revision 0.01 - File Created, first release
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity MAX31865_serial_interface is
    Port ( cs_n     : out std_logic; --MAX31865 Control Signals
           sclk     : out std_logic;
           mosi     : out std_logic;
           miso     : in  std_logic;
           drdy_n   : in  std_logic;
   
           reset_n  : in  std_logic; --Driver Control Signals
           clk_spi      : in  std_logic;
           wr       : in  std_logic;
           addr     : in  std_logic_vector(7 downto 0);
           dat_i    : in  std_logic_vector(7 downto 0);
           dat_o    : out std_logic_vector(7 downto 0));
end MAX31865_serial_interface;

architecture Behavioral of MAX31865_serial_interface is
    signal state : std_logic_vector(1 downto 0);
    signal pol   : std_logic;
    signal pulse : unsigned(3 downto 0);
    signal tmp   : std_logic_vector(15 downto 0);
    signal tmp_o : std_logic_vector(7 downto 0);
    signal cs    : std_logic;
    
begin
    dat_o <= tmp_o;
    sclk <= (not clk_spi) or pol;
    cs_n <= not cs;
    
process (reset_n, clk_spi) is
begin
    if(reset_n = '0') then  --Asynchronous Reset
        state <= "00";
        tmp <= X"0000";
        cs <= '0';
        mosi <= '0';
        pol <= '1';
        pulse <= "0000";
    elsif rising_edge(clk_spi) then
        case state is
            when "00" =>   --Wait for writing or reading pulse
                pol <= '1';
                cs <= '0';
                if(wr = '1') then 
                    state <= "01";
                    pulse <= "0000";
                    tmp(15 downto 8) <= addr;
                    tmp(7 downto 0) <= dat_i;
                end if;
            when "01" =>  --SPI MODE
                pol <= '1';
                cs <= '1';
                state <= "10";
            when "10" =>   --Write and Read SPI
                pol <= '0';
                cs <= '1';
                for i in 14 downto 0 loop
                    tmp(i+1) <= tmp(i);
                end loop;
                mosi <= tmp(15);
                pulse <= pulse + 1;
                if(pulse = 15) then
                    state <= "00";
                end if;
            when others =>
                state <= "00";
        end case;
    end if;
end process;

process (reset_n, clk_spi) is
begin
    if(reset_n = '0') then
        tmp_o <= X"00";
    elsif falling_edge(clk_spi) then
        if(cs = '1') then
            for i in 6 downto 0 loop
                tmp_o(i+1) <= tmp_o(i);
            end loop;
            tmp_o(0) <= miso;
        end if;
    end if;
end process;
end Behavioral;