--device EPP4CE22F17C6
use work.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity example_component is
   port (
      clk, reset    		: in  std_logic;
      address       		: in  std_logic_vector (1 downto 0);
      read      : in  std_logic;
      readdata    	  : out std_logic_vector (31 downto 0);
      write     : in  std_logic;
      writedata     		: in  std_logic_vector (31 downto 0)
   );
end example_component;

architecture simple of example_component is


     signal inreg : std_logic_vector (31 downto 0);
     signal outreg : std_logic_vector (31 downto 0);	
   
   
	
	component comp_codelock PORT( clk:      in  std_logic;
           R:      in  std_logic_vector(1 to 4);
           q:      out std_logic_vector(4 downto 0);
           UNLOCK: out std_logic);
	end component;
for all : comp_codelock use entity work.codelock(behavior);

begin
    g0: comp_codelock PORT MAP(inreg(4), inreg(3 downto 0), outreg(4 downto 0), outreg(5)); 	
    -- CPU is reading data at address.
    process (clk)
      
    begin
      if (rising_edge (clk)) then
        if (read = '1') then
          
          readdata <= outreg ;
        elsif (write = '1') then
          inreg <= writedata;
       
          report "write : data [" & integer'image (to_integer (unsigned (writedata))) & "]";
        
        end if;
      end if;
    end process;

end simple;
