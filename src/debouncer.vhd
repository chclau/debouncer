------------------------------------------------------------------
-- Name        : debouncer.vhd
-- Description : Debounce push button
-- Designed by : Claudio Avi Chami - FPGA Site
--               http://fpgasite.net
-- Date        : 16/July/2016
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
use work.debounce_pack.ALL;

entity debouncer is
   port 
   (
      clk      : in std_logic;
      rst      : in std_logic;
      
      pbutton  : in std_logic;
      pb_deb   : out std_logic
   );
end entity;

architecture rtl of debouncer is

   signal cnt_deb     : unsigned(DIV_DEB_W-1 downto 0);
   signal clk_en      : std_logic;
   signal cnt_threshold : unsigned(DEB_LEN_W-1 downto 0);
   signal pb_deb_i       : std_logic;
   signal pbutton_s   : std_logic;
   
begin
   
   -- downcounter for input clock freq. division   
   process (rst, clk)
   begin
      if (rst = '1') then
         cnt_deb <= (others => '0');
         clk_en   <= '0';
      elsif (rising_edge(clk)) then
         if (cnt_deb = 0) then
            cnt_deb <= to_unsigned(DIV_DEB, cnt_deb'length);
            clk_en   <= '1';
         else  
            cnt_deb <= cnt_deb-1;
            clk_en   <= '0';
         end if;  
      end if;
   end process;      

   -- sample pushbutton and debounce   
   process (rst, clk)
   begin
      if (rst = '1') then
         cnt_threshold <= (others => '0');
         pbutton_s     <= '0';
         pb_deb_i      <= '0';
      elsif (rising_edge(clk)) then
         pbutton_s     <= pbutton;
         if (pbutton_s = '1' and clk_en = '1') then
            if (cnt_threshold < (DEB_LEN-1) ) then
               cnt_threshold <= cnt_threshold + 1;
            end if;  
         end if;  
         if (pbutton_s = '0' and clk_en = '1') then
            if (cnt_threshold > 0 ) then
               cnt_threshold <= cnt_threshold - 1;
            end if;  
         end if;  
         
         -- Activate output with hysteresis
         if (pb_deb_i = '0' and (cnt_threshold > DEB_THRES_HI)) then
            pb_deb_i <= '1';
         end if;
         if (pb_deb_i = '1' and (cnt_threshold < DEB_THRES_LO)) then
            pb_deb_i <= '0';
         end if;
      
      end if;
   end process;      
   
   pb_deb <= pb_deb_i;  
end rtl;
