LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity music is
port (toneOut1 : out std_logic;
	clk_50, resetn : in std_logic;
	LED1 : out std_logic_vector(7 downto 0));
end entity music;

architecture fsm of music is
                                    
type state_type is (Silent, sa,re,ga,ma,pa,dha,ni);  
signal y_present : state_type; 
signal switch1 : std_logic_vector(7 downto 0); 
                                  
signal count : integer ;                                     
                                    
component toneGenerator is
port (clk : in std_logic;
switch : in std_logic_vector(7 downto 0);
toneOut : out std_logic; 
LED : out std_logic_vector(7 downto 0));
end component toneGenerator ;                                     
                                       -- Take the toneGenerator component
                                          ------------------Code here---------------------------
begin

	process(clk_50, resetn, y_present, count, switch1)	-- Fill sensitivity list
	variable y_next_var : state_type;
	variable n_count : integer := 0;
	variable timecounter : integer range 0 to 1E8 := 0;
	variable clock_music : std_logic:='1' ;
	
	begin
	
		y_next_var := y_present;
		n_count := count;
      
		case y_present is
		   
			when Silent=>
			   y_next_var := sa;
		      n_count := n_count + 1 ;
				switch1 <= ( others => '0');
				
			WHEN sa =>	
				if((count = 1 ) or (count = 5) or (count = 9) ) then
    			     y_next_var := sa ;
				     
				elsif ((count = 2 ) or (count = 6) or (count = 10) ) then 
	              y_next_var := ga ;
				     
				elsif ((count = 16) or (count = 31)) then
	              y_next_var := ni ;
					  
				end if;
				n_count := n_count + 1 ;
				
				switch1 <= (0 => '1', others => '0');  
				
			WHEN re =>
		      if((count = 19 ) or (count = 23) or (count = 27) ) then
    			     y_next_var := re ;
				     
				elsif ((count = 20 ) or (count = 24) ) then 
	              y_next_var := ni ;
				     
				elsif ((count = 15) or (count = 30)) then
	              y_next_var := sa ;
					  
				elsif (count = 28 ) then
	              y_next_var := ga ;	  
					  
				end if;
				n_count := n_count + 1 ;
				
				switch1 <= (1 => '1', others => '0');
			
		   WHEN ga =>
		      if((count = 3 ) or (count = 7) or (count = 11) ) then
    			     y_next_var := ga ;
				     
				elsif ((count = 4 ) or (count = 8) ) then 
	              y_next_var := sa ;
				     
				elsif ((count = 14) or (count = 29)) then
	              y_next_var := re ;
					  
				elsif (count = 12 ) then
	              y_next_var := ma ;	  
					  
				end if;
				n_count := n_count + 1 ;
				
				switch1 <= (2 => '1', others => '0');	
				
			when ma => 
		      if(count= 13) then 
			         y_next_var := ga ;
				end if ;
		
		      switch1 <= (3 => '1', others => '0');
				
         when ni =>
		      if((count = 17 ) or (count = 21) or (count = 25) ) then
    			     y_next_var := ni ;
				     
				elsif ((count = 18 ) or (count = 22) or (count = 26 )) then 
	              y_next_var := re ;
				     
				elsif (count = 32 ) then
	              y_next_var := Silent ;	  
					  
				end if;
				n_count := n_count + 1 ;
				
				switch1 <= (6 => '1', others => '0');		
			   
			
			WHEN others =>
			   y_next_var := Silent;
				switch1 <= (others => '0');
				
		END CASE ;
	
      
     if (clk_50 = '1' and clk_50' event) then
			     
			  if timecounter = 6250000 then 
				    timecounter := 1;			 
				    clock_music := not clock_music;		 
  			  else
				    timecounter := timecounter + 1;	
					
			  end if;
			       
     end if;
		    
	                        --		generate 4Hz clock (0.25s time period) from 50MHz clock (clock_music)
			
                             --		state transition	
		if (clock_music = '1' and clock_music' event) then
			if (resetn = '1') then
				y_present <= Silent ;
				count <= 0 ;

			else 
				y_present <= y_next_var ;
				count <= n_count ;
			
			
			end if ;
		end if;
	end process;
	
op1 : toneGenerator port map ( clk_50, switch1,toneOut1, LED1);	-- instantiate the component of toneGenerator 
end fsm;