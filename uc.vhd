----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2024 09:34:29 AM
-- Design Name: 
-- Module Name: uc - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uc is
Port (
opcode: in std_logic_vector(5 downto 0);
aluop: out std_logic_vector(2 downto 0);
memtoreg: out std_logic;
memwrite: out std_logic;
jump: out std_logic;
branch: out std_logic;
alusrc: out std_logic;
regwrite: out std_logic;
regdst: out std_logic;
extop: out std_logic
);
end uc;

architecture Behavioral of uc is

begin

process(opcode)
begin
memtoreg<='0';
memwrite<='0';
jump<='0';
branch<='0';
alusrc<='0';
regwrite<='0';
regdst<='0';
extop<='0';
aluop<="000";

    case opcode is 
        when "000000" =>
            regwrite<='1';
            regdst<='1';
            aluop<="000";
        when "001000" =>
            extop<='1';
            alusrc<='1';
            regwrite<='1';
            aluop<="001";
        when "100011" =>
            extop<='1';
            alusrc<='1';
            memtoreg<='1';
            regwrite<='1';
            aluop<="001";
        when "101011" =>
            extop<='1';
            alusrc<='1';
            memwrite<='1';
            aluop<="001";
        when "000100" =>
            extop<='1';
            branch<='1';
            aluop<="010";
        when "001100" =>
            alusrc<='1';
            regwrite<='1';
            aluop<="011";
        when "001101" =>
            alusrc<='1';
            regwrite<='1';
            aluop<="100";
        when "000010" =>
            jump<='1';
        when others => aluop<="100";
    end case;


end process;

end Behavioral;
