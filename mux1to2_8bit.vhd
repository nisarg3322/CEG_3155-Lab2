library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for 1-to-2 MUX
entity mux1to2_8bit is
    Port (
        sel : in  STD_LOGIC;            -- 1-bit select line
        d0  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 0
        d1  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 1
        y   : out STD_LOGIC_VECTOR(7 downto 0)  -- 8-bit output selected by sel
    );
end mux1to2_8bit;

-- Architecture declaration for 1-to-2 MUX
architecture rtl of mux1to2_8bit is
begin
    -- Process to implement MUX functionality
    process(sel, d0, d1)
    begin
        -- Output selected by sel
        case sel is
            when '0' =>
                y <= d0;
            when '1' =>
                y <= d1;
            when others =>
                y <= (others => '0'); -- Default case for safety
        end case;
    end process;

end rtl;
