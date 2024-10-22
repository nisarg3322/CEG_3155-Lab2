library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Datapath is
    Port (
        dividend    : in  STD_LOGIC_VECTOR(3 downto 0); -- 4-bit signed dividend
        divisor     : in  STD_LOGIC_VECTOR(3 downto 0); -- 4-bit signed divisor
        load        : in  STD_LOGIC;                    -- Load signal to initialize division
        shift       : in  STD_LOGIC;                    -- Shift signal to shift dividend/remainder
        subtract    : in  STD_LOGIC;                    -- Subtract signal for divisor from remainder
        clk         : in  STD_LOGIC;                    -- Clock signal
        temp_quotient  : out STD_LOGIC_VECTOR(7 downto 0); -- 8-bit quotient
        temp_remainder : out STD_LOGIC_VECTOR(7 downto 0); -- 8-bit remainder
        temp_dividend  : out STD_LOGIC_VECTOR(7 downto 0); -- 8-bit dividend (extended)
        same_sign   : out STD_LOGIC                     -- 1 if same sign, 0 if different sign
    );
end Datapath;

architecture Behavioral of Datapath is
    signal internal_dividend   : STD_LOGIC_VECTOR(7 downto 0); -- 8-bit extended dividend
    signal internal_remainder  : STD_LOGIC_VECTOR(7 downto 0); -- 8-bit remainder
    signal internal_quotient   : STD_LOGIC_VECTOR(7 downto 0); -- 8-bit quotient
begin

    -- Check if dividend and divisor have the same sign
    process(dividend, divisor)
    begin
        if (dividend(3) xor divisor(3)) = '0' then
            same_sign <= '1'; -- Same sign (both positive or both negative)
        else
            same_sign <= '0'; -- Different signs (one positive, one negative)
        end if;
    end process;

    -- Datapath for shifting and subtraction
    process(clk)
    begin
        if rising_edge(clk) then
            if load = '1' then
                -- Load the dividend and initialize
                internal_dividend(3 downto 0) <= dividend; -- Load the 4-bit dividend
                internal_dividend(7 downto 4) <= (others => '0'); -- Zero-extend the dividend
                internal_quotient <= (others => '0'); -- Initialize quotient to zero
                internal_remainder <= (others => '0'); -- Initialize remainder to zero
            elsif shift = '1' then
                -- Shift remainder and dividend
                internal_remainder <= internal_remainder(6 downto 0) & internal_dividend(7);
                internal_dividend <= internal_dividend(6 downto 0) & '0';
            elsif subtract = '1' then
                -- Subtract divisor from remainder if greater than or equal
                if internal_remainder >= ("0000" & divisor) then
                    internal_remainder <= internal_remainder - ("0000" & divisor);
                    internal_quotient <= internal_quotient or ("00000001" after internal_quotient);
                end if;
            end if;
        end if;
    end process;

    -- Output connections
    temp_quotient <= internal_quotient;
    temp_remainder <= internal_remainder;
    temp_dividend <= internal_dividend;

end Behavioral;

