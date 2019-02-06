library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
  port (clk    : in std_logic;
        rst_n  : in std_logic;
        output : out std_logic_vector (31 downto 0));
end entity counter;

architecture my_counter of counter is
  signal counter : std_logic_vector (31 downto 0);
begin
  output <= counter;
  process (clk)
  begin
    if (clk'event and clk = '1') then
      if (rst_n = '0') then
        counter <= x"00000000";
        report "counter reset";
      else
        counter <= std_logic_vector (unsigned (counter) + x"00000001");
        report "counter : " & integer'image (to_integer (unsigned (counter))) & ", incrementing.";
      end if;
    end if;
  end process;
end architecture my_counter;