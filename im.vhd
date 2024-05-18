----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2024 05:12:12 PM
-- Design Name: 
-- Module Name: im - Behavioral
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


entity im is
Port (adress: in std_logic_vector(4 downto 0);
data: out std_logic_vector(31 downto 0)
);
end im;

architecture Behavioral of im is

type mem_rom is array (0 to 31) of std_logic_vector(31 downto 0);
signal mem: mem_rom := (
                        --registrul 31 <- lungimea sirului din memorie(6) prin adunarea valorii registrului 0 cu 6
                        B"001000_00000_11111_0000000000000110", --addi  --4
                        --beq sa sara peste instructiunile din bucla daca valoarea registrului 30 ajunge egala cu 6 prin incrementare 
                        B"000100_11110_11111_0000000000001011", --beq    --8 sare la ultima instructiune dupa 6 iteratii 
                        
                        --pun in registrul 1 valoarea 0 pentru comparatie
                        B"001000_00000_00001_0000000000000000", --addi   --c
                        --pun in registrul 3 valoarea din memorie de la adresa indicata de registrul 2
                        B"100011_00010_00011_0000000000000000", --lw     --10
                        -- pun in registrul 4 valoarea de la adresa registrului 2 ca auxiliar                        
                        B"100011_00010_00100_0000000000000000", --lw     --14
                        --pun in registrul 3 valoarea din memorie and 000..1
                        B"001100_00011_00011_0000000000000001", --andi  --18
                        --face beq daca e par  
                        B"000100_00011_00001_0000000000000010", --beq  --1c --sare la 28 daca acum am par
                        
                        --adun numarul impar la registrul 29
                        B"000000_11101_00100_11101_00000_000001", --add --20   
                        --sare peste incrementarea numerelor pare daca numarul e impar   
                        B"000010_00000000000000000000001010", --jump 24 --sare la 2c daca impar
                        
                         --incrementez numarul de numere pare (registrul 28)
                        B"001000_11100_11100_0000000000000001", --addi 28
                        
                        --incrementam registrul 2 cu 4
                        B"001000_00010_00010_0000000000000100", --addi   2c 
                        --incrementm registrul 30 cu 1
                        B"001000_11110_11110_0000000000000001",  --addi --30
                        --sare inapoi la beq   
                        B"000010_00000000000000000000000000", --jump 34  --sare la 8 daca avem mai putin de 6 iteratii
                        --pun in 27 valoarea 1
                        B"000000_11101_11100_11011_00000_000001", --add --38      

                        others => X"00000000"
);

begin
data<=mem(conv_integer(adress));
end Behavioral;
