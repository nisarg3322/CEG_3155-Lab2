library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for 2-to-4 MUX
entity mux2to41bit is
    Port (
        sel : in  STD_LOGIC_VECTOR(1 downto 0); -- 2-bit select lines
        d0  : in  STD_LOGIC;
        d1  : in  STD_LOGIC;
        d2  : in  STD_LOGIC;
        d3  : in  STD_LOGIC;
        y   : out STD_LOGIC
    );
end mux2to41bit;

-- Architecture declaration for 2-to-4 MUX
architecture rtl of mux2to41bit is
begin
    -- Process to implement MUX functionality
    process(sel, d0, d1, d2, d3)
    begin
        -- Output selected by sel
        case sel is
            when "00" =>
                y <= d0;
            when "01" =>
                y <= d1;
            when "10" =>
                y <= d2;
            when "11" =>
                y <= d3;
            when others =>
                y <=  '0'; -- Default case for safety
        end case;
    end process;

end rtl;