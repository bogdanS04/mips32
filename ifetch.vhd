----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2024 12:04:15 PM
-- Design Name: 
-- Module Name: ifetch - Behavioral
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

entity ifetch is
Port (jump: in std_logic;
jumpadress: in std_logic_vector(31 downto 0);
pcsrc: in std_logic;
branchadress: in std_logic_vector(31 downto 0);
en: in std_logic;
rst: in std_logic;
clk: in std_logic;
pcplus4: out std_logic_vector(31 downto 0);
instruction: out std_logic_vector(31 downto 0));
end ifetch;

architecture Behavioral of ifetch is

component im is 
port(adress: in std_logic_vector(4 downto 0);
data: out std_logic_vector(31 downto 0));
end component;

component pc is 
port(clk: in std_logic;
rst: in std_logic;
d: in std_logic_vector(31 downto 0);
q: out std_logic_vector(31 downto 0);
en: in std_logic);
end component;

signal muxout: std_logic_vector(31 downto 0);
signal d: std_logic_vector(31 downto 0);
signal q: std_logic_vector(31 downto 0);


begin

pcounter: pc port map(clk=>clk, rst=>rst, d=>d, q=>q, en=>en);
imemory: im port map(adress=>q(6 downto 2), data=>instruction);


pcplus4<=q+4;
muxout<=q+4 when pcsrc='0'else branchadress;
d<=muxout when jump='0' else jumpadress;


end Behavioral;
