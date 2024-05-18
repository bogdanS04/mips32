----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2024 09:50:23 PM
-- Design Name: 
-- Module Name: mem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is
Port ( 
memwrite: in std_logic;
aluresin: in std_logic_vector(31 downto 0);
rd2: in std_logic_vector(31 downto 0);
clk: in std_logic;
en: in std_logic;
memdata: out std_logic_vector(31 downto 0);
aluresout: out std_logic_vector(31 downto 0)
);
end mem;

architecture Behavioral of mem is
type memory is array (0 to 63) of std_logic_vector(31 downto 0);
signal mem: memory:=("00000000000000000000000000000001", --1
                                "00000000000000000000000000000011", --3
                                "00000000000000000000000000000010", --2
                                "00000000000000000000000000001101", --13
                                "00000000000000000000000000000100", --4
                                "00000000000000000000000000000111", --7
                                others => X"00000000");
signal adress: std_logic_vector(5 downto 0);
begin

adress<=aluresin(7 downto 2);

process(clk)
begin
    if rising_edge(clk) then 
        if en='1' and memwrite='1' then
            mem(conv_integer(adress))<=rd2;
        end if;
    end if;
end process;
aluresout<=aluresin;
memdata<=mem(conv_integer(adress));
end Behavioral;
