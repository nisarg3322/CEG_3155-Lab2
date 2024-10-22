LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY twosComplementer IS
    GENERIC (
        N : INTEGER := 8  -- Default bit width is 8
    );
    PORT(
        i_Value : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        o_Value : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END twosComplementer;

ARCHITECTURE rtl OF twosComplementer IS
    SIGNAL int_Value : SIGNED(N-1 DOWNTO 0);
BEGIN
    -- Convert input to signed, negate it, and add 1 for two's complement
    int_Value <= -SIGNED(i_Value);

    -- Convert the result back to std_logic_vector
    o_Value <= STD_LOGIC_VECTOR(int_Value);

END rtl;
