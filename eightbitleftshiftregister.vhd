

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitLeftShiftRegister IS
    PORT(
        i_resetBar : IN STD_LOGIC;
        i_load     : IN STD_LOGIC;  -- Load signal (if needed)
        i_enable   : IN STD_LOGIC;  -- Enable signal to shift
        i_clock    : IN STD_LOGIC;  -- Clock signal
        i_Value    : IN STD_LOGIC_VECTOR(7 downto 0);  -- Input value
        o_Value    : OUT STD_LOGIC_VECTOR(7 downto 0)   -- Output value
    );
END eightBitLeftShiftRegister;

ARCHITECTURE structural OF eightBitLeftShiftRegister IS
    COMPONENT enARdFF_2
        PORT(
            i_resetBar : IN STD_LOGIC;
            i_d        : IN STD_LOGIC;
            i_enable   : IN STD_LOGIC;
            i_clock    : IN STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL q_signals : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL qBar_signals : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL mux_out : STD_LOGIC_VECTOR(7 downto 0);

BEGIN
    -- Multiplexer logic to select between load value and shifted value
    mux_out(0) <= i_Value(0) WHEN i_load = '1' ELSE '0';
    mux_out(1) <= i_Value(1) WHEN i_load = '1' ELSE q_signals(0);
    mux_out(2) <= i_Value(2) WHEN i_load = '1' ELSE q_signals(1);
    mux_out(3) <= i_Value(3) WHEN i_load = '1' ELSE q_signals(2);
    mux_out(4) <= i_Value(4) WHEN i_load = '1' ELSE q_signals(3);
    mux_out(5) <= i_Value(5) WHEN i_load = '1' ELSE q_signals(4);
    mux_out(6) <= i_Value(6) WHEN i_load = '1' ELSE q_signals(5);
    mux_out(7) <= i_Value(7) WHEN i_load = '1' ELSE q_signals(6);

    -- Instantiate each flip-flop and connect them structurally
    ff0: enARdFF_2 PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => mux_out(0),
        i_enable   => i_enable OR i_load,
        i_clock    => i_clock,
        o_q        => q_signals(0),
        o_qBar     => qBar_signals(0)
    );

    ff1: enARdFF_2 PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => mux_out(1),
        i_enable   => i_enable OR i_load,
        i_clock    => i_clock,
        o_q        => q_signals(1),
        o_qBar     => qBar_signals(1)
    );

    ff2: enARdFF_2 PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => mux_out(2),
        i_enable   => i_enable OR i_load,
        i_clock    => i_clock,
        o_q        => q_signals(2),
        o_qBar     => qBar_signals(2)
    );

    ff3: enARdFF_2 PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => mux_out(3),
        i_enable   => i_enable OR i_load,
        i_clock    => i_clock,
        o_q        => q_signals(3),
        o_qBar     => qBar_signals(3)
    );

    ff4: enARdFF_2 PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => mux_out(4),
        i_enable   => i_enable OR i_load,
        i_clock    => i_clock,
        o_q        => q_signals(4),
        o_qBar     => qBar_signals(4)
    );

    ff5: enARdFF_2 PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => mux_out(5),
        i_enable   => i_enable OR i_load,
        i_clock    => i_clock,
        o_q        => q_signals(5),
        o_qBar     => qBar_signals(5)
    );

    ff6: enARdFF_2 PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => mux_out(6),
        i_enable   => i_enable OR i_load,
        i_clock    => i_clock,
        o_q        => q_signals(6),
        o_qBar     => qBar_signals(6)
    );

    ff7: enARdFF_2 PORT MAP (
        i_resetBar => i_resetBar,
        i_d        => mux_out(7),
        i_enable   => i_enable OR i_load,
        i_clock    => i_clock,
        o_q        => q_signals(7),
        o_qBar     => qBar_signals(7)
    );

    -- Output assignment
    o_Value <= q_signals;

END structural;

