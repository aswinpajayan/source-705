library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity comp_multiplier is
   port (
      clk, reset    : in  std_logic;
      address       : in  std_logic_vector (2 downto 0);  --changed to three bit address to address 5 registers 
      read          : in  std_logic;
      readdata      : out std_logic_vector (31 downto 0);
      write         : in  std_logic;
      writedata     : in  std_logic_vector (31 downto 0)
   );
end comp_multiplier;

architecture simple of comp_multiplier is

   signal control_and_status_reg : std_logic_vector (31 downto 0);
   signal operand_a              : std_logic_vector (31 downto 0);
   signal operand_b              : std_logic_vector (31 downto 0);
   signal result_value           : std_logic_vector (63 downto 0);

   type tState is (stIDLE, stSTART, stPROCESSING, stFINISH);
   signal state : tState;

begin

    -- CPU is reading data at address.
    process (clk)
      		
	variable r_mat : std_logic_vector (63 downto 0);
	    variable out_data : std_logic_vector (31 downto 0);
    begin
      if (rising_edge (clk)) then
	      if (read = '1') then
          case address is
            when "000" => out_data :=control_and_status_reg; 
            when "001" => out_data := opearand_a;
            when "010" => out_data := operand_b;
            when "011" => out_data := result_value(31 downto 0);
	    when "100" => out_data := result_value(63 downto 32);
            when others => null;
          end case;
          readdata <= out_data;
          --report "read : address [" & integer'image (to_integer (unsigned (address))) & "]";
          --report "read : data [" & integer'image (to_integer (unsigned (out_data))) & "]";
        elsif (write = '1') then
          case address is
            when "00" => 
              if (writedata = x"00000001") then
                  state <= stSTART;
              end if;
              control_and_status_reg <= writedata;
            when "01" => operand_a              <= writedata;
            when "10" => operand_b              <= writedata;
            when others => null;
          end case;
          --report "write : address [" & integer'image (to_integer (unsigned (address))) & "]";
          --report "write : data [" & integer'image (to_integer (unsigned (writedata))) & "]";
        else
          case state is
            when stSTART =>
              control_and_status_reg <= x"00000003";
              state <= stPROCESSING;
            when stPROCESSING =>
   
		     for I in 0 to 2 loop
       for J in 0 to 2 loop
           r_mat((6*(3*I+J)+5) downto (6*(3*I+J))) := b"000000";
           for K in 0 to 2 loop
             r_mat((6*(3*I+J)+5) downto (6*(3*I+J))) :=unsigned(r_mat((6*(3*I+J)+5) downto (6*(3*I+J)))) + (unsigned( operand_a((6*I+2*K+1) downto (6*I+2*K))) * unsigned( operand_b((6*K+2*J+1) downto (6*K+2*J))));

           end loop;
       end loop;
   end loop;
 result_value<=r_mat;
		    
		    
		    
		    
		    
		    
		    
		    
		    state <= stFINISH;
            when stFINISH =>
              control_and_status_reg <= x"00000000";
              state <= stIDLE;
            when stIDLE =>
              state <= stIDLE;
          end case;
        end if;
      end if;
    end process;

end simple;

