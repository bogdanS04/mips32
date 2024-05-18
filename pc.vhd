library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
port(clk: in std_logic;
rst: in std_logic;
d: in std_logic_vector(31 downto 0);
q: out std_logic_vector(31 downto 0);
en: in std_logic);
end pc;

architecture Behavioral of pc is

begin

  process(clk, rst)
  begin
    if rst='1' then
      q <= (others => '0' );
    elsif rising_edge(clk) then
    if en='1' then
      q<=d;
      end if;
    end if;
  end process;

end Behavioral;