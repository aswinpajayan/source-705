library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity codelock is
   port( clk:      in  std_logic;
           R:      in  std_logic_vector(1 to 4);
           q:      out std_logic_vector(4 downto 0);
           UNLOCK: out std_logic );
end codelock;

architecture behavior of codelock is
subtype state_type is integer range 0 to 33;
signal state, nextstate: state_type;
  
begin
nextstate_decoder: -- next state decoding part
process(state,R)
 begin
   case state is
      when 0 => if ( R ="0001")     then nextstate <= 1;
                else nextstate <= 0;
                end if;
      when 1 => if ( R ="0001")     then nextstate <= 1;
                elsif ( R = "0000") then nextstate <= 2;
                else nextstate <= 0;
                end if;
		
      when 2 => if ( R ="0100")     then nextstate <= 3;
                elsif ( R = "0000") then nextstate <= 2;
                else nextstate <= 0;
                end if;
      when 3 => if ( R ="0100")     then nextstate <= 3;
                elsif ( R = "0000") then nextstate <= 4;
		else  nextstate <= 0;
                end if;
      when 4 to 32 => nextstate <= state + 1;
      when 33      => nextstate <= 0;
   end case;
end process;

debug_output:  -- display the state
q <= conv_std_logic_vector(state,5); 
	
output_decoder: -- output decoder part
process(state)
begin
  case state is
     when 0 to 3  => UNLOCK <= '0';
     when 4 to 33 => UNLOCK <= '1';
  end case;	
end process;

state_register: -- the state register part (the flipflops)
process(clk)
begin
  if rising_edge(clk) then
     state <= nextstate;
  end if;
end process;
end behavior;