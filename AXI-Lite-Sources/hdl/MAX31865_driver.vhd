----------------------------------------------------------------------------------
-- This code is release under CERN Open Hardware Licence Version 2 - Strongly Reciprocal
-- You can read license details in: https://ohwr.org/cern_ohl_s_v2.txt
-- Company: FaultyProject
-- Engineer: Abraham Lemos Perez
-- 
-- Create Date: 18.09.2022 23:34:45
-- Module Name: MAX31865_driver - Behavioral
-- Target Devices: FPGA
-- Tool Versions: Vivado 2020.2
-- Description: VHDL Driver for MAX31865
-- 
-- Dependencies: MAX31865_CONSTANTS.vhd
--               serial_interface.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created, first release
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.MAX31865_CONSTANTS.ALL;

entity MAX31865_driver is
    Port ( cs_n     : out std_logic; --MAX31865 Control Signals
           sclk     : out std_logic;
           mosi     : out std_logic;
           miso     : in  std_logic;
           drdy_n   : in  std_logic;
   
           reset_n  : in  std_logic; --Driver Control Signals
           clk_spi      : in  std_logic;
           rtd_val  : out STD_LOGIC_VECTOR (15 downto 0));
end MAX31865_driver;

architecture Behavioral of MAX31865_driver is
    signal state        : unsigned(STATE_BITS-1 downto 0);
    signal state_p      : unsigned(STATE_BITS-1 downto 0);
    signal count_clk    : unsigned(19 downto 0);
    signal spi_wr       : std_logic;
    signal spi_addr     : std_logic_vector(7 downto 0);
    signal spi_data_w   : std_logic_vector(7 downto 0);
    signal spi_data_r   : std_logic_vector(7 downto 0);
    
    component MAX31865_serial_interface is
    Port ( cs_n     : out std_logic;
           sclk     : out std_logic;
           mosi     : out std_logic;
           miso     : in  std_logic;
           drdy_n   : in  std_logic;

           reset_n  : in  std_logic;
           clk_spi      : in  std_logic;
           wr       : in  std_logic;
           addr     : in  std_logic_vector(7 downto 0);
           dat_i    : in  std_logic_vector(7 downto 0);
           dat_o    : out  std_logic_vector(7 downto 0));
    end component MAX31865_serial_interface;
    
begin
    serial : MAX31865_serial_interface port map (
        cs_n => cs_n,
        sclk => sclk,
        mosi => mosi,
        miso => miso,
        drdy_n => drdy_n,
        reset_n => reset_n,
        clk_spi => clk_spi,
        wr => spi_wr,
        addr => spi_addr,
        dat_i => spi_data_w,
        dat_o => spi_data_r );
        
process (reset_n, clk_spi) is
begin
    if(reset_n = '0') then
        state <= S_CONFIG;
        count_clk <= X"00000";
        spi_wr <= '0';
        spi_addr <= X"00";
        spi_data_w <= X"00";
        rtd_val <= X"0000";
    elsif rising_edge(clk_spi) then
        case state is
            when S_CONFIG =>
                spi_addr <= ADD_CONFIG;
                spi_data_w <= X"03";
                state_p <= state;
                state <= WR_SPI;
            when S_HIGH_MSB_THRESHOLD =>
                spi_addr <= ADD_HIGH_MSB_THRESHOLD;
                spi_data_w <= X"FF";
                state_p <= state;
                state <= WR_SPI;
            when S_HIGH_LSB_THRESHOLD =>
                spi_addr <= ADD_HIGH_LSB_THRESHOLD;
                spi_data_w <= X"FF";
                state_p <= state;
                state <= WR_SPI;
            when S_LOW_MSB_THRESHOLD =>
                spi_addr <= ADD_LOW_MSB_THRESHOLD;
                spi_data_w <= X"00";
                state_p <= state;
                state <= WR_SPI;
            when S_LOW_LSB_THRESHOLD =>
                spi_addr <= ADD_LOW_LSB_THRESHOLD;
                spi_data_w <= X"00";
                state_p <= state;
                state <= WR_SPI;
            when S_BIAS_ON =>
                spi_addr <= ADD_CONFIG;
                spi_data_w <= X"81";
                state_p <= state;
                state <= WR_SPI;
            when S_WAIT_1 =>
                count_clk <= count_clk + 1;
                if count_clk = 100000 then   --100000 to 20ms 3 to sim
                    state <= state + 1;
                    count_clk <= X"00000";
                end if;
            when S_1_SHOT =>
                spi_addr <= ADD_CONFIG;
                spi_data_w <= X"A1";
                state_p <= state;
                state <= WR_SPI;
            when S_WAIT_2 =>
                if drdy_n = '0' then
                    state <= state + 1;
                end if;
            when S_BIAS_OFF =>
                spi_addr <= ADD_CONFIG;
                spi_data_w <= X"01";
                state_p <= state;
                state <= WR_SPI;
            when S_READ_H_W =>
                spi_addr <= ADD_RTD_MSB;
                spi_data_w <= X"FF";
                state_p <= state;
                state <= WR_SPI;
            when S_READ_H_R =>
                rtd_val(15 downto 8) <= spi_data_r;
                state <= S_READ_L_W;
            when S_READ_L_W =>
                spi_addr <= ADD_RTD_LSB;
                spi_data_w <= X"FF";
                state_p <= state;
                state <= WR_SPI;
            when S_READ_L_R =>
                rtd_val(7 downto 0) <= spi_data_r;
                state <= S_WAIT_3;
            when S_WAIT_3 =>
                count_clk <= count_clk + 1;
                if count_clk = X"FFFFF" then   --X"FFFFF" to 230ms 5 to sim
                    state <= S_BIAS_ON;
                    count_clk <= X"00000";
                end if;
            when WR_SPI =>
                if count_clk = X"00000" then
                    spi_wr <= '1';
                    count_clk <= count_clk + 1;
                else
                    spi_wr <= '0';
                    count_clk <= count_clk + 1;
                    if count_clk = 18 then
                        state <= state_p + 1;
                        count_clk <= X"00000";
                    end if;
                end if;
            when others =>
                state <= S_CONFIG;
                count_clk <= X"00000";
        end case;
    end if;
end process;
end Behavioral;