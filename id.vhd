----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2024 01:46:57 PM
-- Design Name: 
-- Module Name: id - Behavioral
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

entity id is
Port (
clk: in std_logic;
regwrite: in std_logic;
instr: in std_logic_vector(25 downto 0);
regdst: in std_logic;
en: in std_logic;
extop: in std_logic;
rd1: out std_logic_vector(31 downto 0);
rd2: out std_logic_vector(31 downto 0);
wd: in std_logic_vector(31 downto 0);
ext_imm: out std_logic_vector(31 downto 0);
func: out std_logic_vector(5 downto 0);
sa: out std_logic_vector(4 downto 0)
 );
end id;

architecture Behavioral of id is

component reg_file is 
port( clk : in std_logic;
ra1 : in std_logic_vector(4 downto 0);
ra2 : in std_logic_vector(4 downto 0);
wa : in std_logic_vector(4 downto 0);
wd : in std_logic_vector(31 downto 0);
regwr : in std_logic;
rd1 : out std_logic_vector(31 downto 0);
rd2 : out std_logic_vector(31 downto 0));
end component;

signal wa: std_logic_vector(4 downto 0);


begin
wa<=instr(20 downto 16) when regdst='0' else instr(15 downto 11);
register_file: reg_file port map (clk=>clk, ra1=>instr(25 downto 21), ra2=>instr(20 downto 16), wa=>wa, wd=>wd, regwr=>en,rd1=>rd1, rd2=>rd2);
func<=instr(5 downto 0);
sa<=instr(10 downto 6);

process(extop)
begin
    if extop='0'then 
        ext_imm<=x"0000"&instr(15 downto 0);
    else
        ext_imm<=instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15)&instr(15 downto 0);
    end if;
end process;


end Behavioral;
