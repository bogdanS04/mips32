----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2024 06:36:23 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port (clk: in std_logic;
    btn: in std_logic_vector(4 downto 0);
    sw: in std_logic_vector(15 downto 0);
    led: out std_logic_vector(15 downto 0);
    an: out std_logic_vector(7 downto 0);
    cat: out std_logic_vector(6 downto 0));
end test_env;

architecture Behavioral of test_env is

component ifetch is
Port (jump: in std_logic;
jumpadress: in std_logic_vector(31 downto 0);
pcsrc: in std_logic;
branchadress: in std_logic_vector(31 downto 0);
en: in std_logic;
rst: in std_logic;
clk: in std_logic;
pcplus4: out std_logic_vector(31 downto 0);
instruction: out std_logic_vector(31 downto 0));
end component;

component id is
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
end component;

component mpg is
Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component ssd is 
Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component ex is 
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
end component;

component mem is 
Port ( 
memwrite: in std_logic;
aluresin: in std_logic_vector(31 downto 0);
rd2: in std_logic_vector(31 downto 0);
clk: in std_logic;
en: in std_logic;
memdata: out std_logic_vector(31 downto 0);
aluresout: out std_logic_vector(31 downto 0)
);
end component;

component uc is 
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
end component;

signal rst, en, jump, pcsrc, regwrite, regdst, extop, alusrc, zero, memwrite,memtoreg, branch: std_logic:='0';
signal jumpadress, branchadress, pcplus4, instruction, rd1, rd2, wd, ext_imm, alures, memdata, aluresout, digits: std_logic_vector(31 downto 0);
signal func: std_logic_vector(5 downto 0);
signal sa: std_logic_vector(4 downto 0);
signal aluop: std_logic_vector(2 downto 0);
begin


pcsrc<=zero and branch;
rst<=btn(1);
jumpadress<=pcplus4(31 downto 28)&instruction(25 downto 0)&"00";
wd <= aluresout when memtoreg='0' else memdata;

mpg_component: mpg port map(enable=>en, btn=>btn(0), clk=>clk);

ifetch_component: ifetch port map(jump=>jump,
jumpadress=>jumpadress,
pcsrc=>pcsrc, 
branchadress=>branchadress,
en=>en, 
rst=>rst,
clk=>clk,
pcplus4=>pcplus4,
instruction=>instruction);

id_component: id port map(
    clk     => clk,
    regwrite => regwrite,
    instr   => instruction(25 downto 0),
    regdst  => regdst,
    en      => en,
    extop   => extop,
    rd1     => rd1,
    rd2     => rd2,
    wd      => wd,
    ext_imm => ext_imm,
    func    => func,
    sa      => sa
);

ex_inst : ex
port map (
    rd1          => rd1,
    alusrc       => alusrc,
    rd2          => rd2,
    ext_imm      => ext_imm,
    sa           => sa,
    func         => func,
    aluop        => aluop,
    pcplus4      => pcplus4,
    zero         => zero,
    alures       => alures,
    branchadress => branchadress
);

mem_inst : mem
port map (
    memwrite   => memwrite,
    aluresin   => alures,
    rd2        => rd2,
    clk        => clk,
    en         => en,
    memdata    => memdata,
    aluresout  => aluresout
);

uc_inst : uc
port map (
    opcode    => instruction(31 downto 26),
    aluop     => aluop,
    memtoreg  => memtoreg,
    memwrite  => memwrite,
    jump      => jump,
    branch    => branch,
    alusrc    => alusrc,
    regwrite  => regwrite,
    regdst    => regdst,
    extop     => extop
);

ssd_inst : ssd
port map (
    clk    => clk,
    digits => digits, 
    an     => an,
    cat    => cat
);

process(sw(7 downto 5))
begin
    case sw(7 downto 5) is 
        when "000" => digits<=instruction;
        when "001" => digits<=pcplus4;
        when "010" => digits<=rd1;
        when "011" => digits<=rd2;
        when "100" => digits<=ext_imm;
        when "101" => digits<=alures;
        when "110" => digits<=memdata;
        when "111" => digits<=wd;
        when others => digits<=wd;
    end case;
end process;

led(0)<=regwrite;
led(1)<=memtoreg;
led(2)<=memwrite;
led(3)<=jump;
led(4)<=branch;
led(5)<=alusrc;
led(6)<=extop;
led(7)<=regdst;

end Behavioral;







