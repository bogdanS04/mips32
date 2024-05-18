----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2024 02:50:00 PM
-- Design Name: 
-- Module Name: ex - Behavioral
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

entity ex is
Port (
rd1: in std_logic_vector(31 downto 0);
alusrc: in std_logic;
rd2: in std_logic_vector(31 downto 0);
ext_imm: in std_logic_vector(31 downto 0);
sa: in std_logic_vector(4 downto 0);
func: in std_logic_vector(5 downto 0);
aluop: in std_logic_vector(2 downto 0);
pcplus4: in std_logic_vector(31 downto 0);
zero: out std_logic;
alures: out std_logic_vector(31 downto 0);
branchadress: out std_logic_vector(31 downto 0) 
 );
end ex;

architecture Behavioral of ex is

signal aluctrl: std_logic_vector(2 downto 0);
signal a, b, c: std_logic_vector(31 downto 0);
begin

alucontrol: process(aluop, func)
begin
    case aluop is
        when "000" =>
            case func is 
                when "000001" => aluctrl<="000";
                when "000010" => aluctrl<="001";
                when "000011"=> aluctrl<="010";
                when "000100"=> aluctrl<="011";
                when "000101"=> aluctrl<="100";
                when "000110"=> aluctrl<="101";
                when "000111"=> aluctrl<="110";
                when "001000"=> aluctrl<="111";
                when others => aluctrl<="000";
             end case;
        when "001" => aluctrl<="000";
        when "010" => aluctrl<="001";
        when "011" => aluctrl<="010";
        when "100" => aluctrl<="011";
        when others=> aluctrl<="010";
     end case;
end process;

branchadress<=pcplus4 + (ext_imm(29 downto 0)&"00");
b<=rd2 when alusrc='0' else ext_imm;
a<=rd1;

process(a, b, aluctrl, sa)
begin 
    case aluctrl is 
        when "000" =>  c<=a+b;
        when "001" =>  c<=a-b;
        when "010" =>  c<= a and b;
        when "011" =>  c<= a or b;
        when "100" =>  c<= a xor b;
        when "101" =>  c<=to_stdlogicvector(to_bitvector(b) sll conv_integer(sa));
        when "110" =>  c<=to_stdlogicvector(to_bitvector(b) srl conv_integer(sa));
        when "111" =>  c<=to_stdlogicvector(to_bitvector(b) sra conv_integer(sa));
        when others => c<=(others=>'X');
    end case;
end process;

alures<=c;
zero <= '1' when c=x"00000000" else '0'; 

end Behavioral;
