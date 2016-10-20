------------------------------------------------------------------
-- Name		   : debounce_pack.vhd
-- Description : Definitions file
-- Project     : Debouncer
-- Designed by : Claudio Avi Chami - FPGA Site
--               https://fpgasite.wordpress.com
-- Date        : 16/July/2016
-- Version     : 01
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package debounce_pack  is

-------------------------------------------------------------------------
-- Clock definitions
------------------------------------------------------------------------- 
  constant SYS_FREQ     : natural := 100_000;		-- Clock freq. in kHz
  constant SYS_PERIOD   : natural := 1_000_000/SYS_FREQ; 	 -- In nanosec., 10 nsec for 100MHz clock
  constant DIV_DEB      : natural := 500_000/SYS_PERIOD;     -- Clock divider for 500us from 100MHz
  constant DIV_DEB_W    : natural := integer(ceil(log2(real(DIV_DEB+1))));	

  
-------------------------------------------------------------------------
-- Size definitions
------------------------------------------------------------------------- 
  constant DEB_LEN		: natural := 32;			
  constant DEB_LEN_W	   : natural := integer(ceil(log2(real(DEB_LEN+1))));			
  constant DEB_THRES_LO	: natural := DEB_LEN/10;			
  constant DEB_THRES_HI	: natural := 9*DEB_LEN/10;			
  
end debounce_pack;

