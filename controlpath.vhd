library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlpath is
    port(
        i_bit0 : in std_logic;
        i_A, i_B : in std_logic_vector(3 downto 0);
        i_resetBar : in std_logic;
        i_clock : in std_logic;
        o_compA, o_compB, o_load_FA, o_load_FB, o_load_product, o_shift_left_A, o_shift_right_B : out std_logic);
end controlpath;

architecture rtl of controlpath is 
    signal s0, s0_bar, s1, s1_bar, s2, s2_bar, s3, s3_bar, s4, s4_bar, s5, s5_bar, s6, s6_bar , reset : std_logic;
    signal cnt : unsigned(2 downto 0);
    signal continue_cnt : std_logic;
    component dFF_2
        port(
            i_d, i_clock : in std_logic;
            o_q, o_qBar : out std_logic);
    end component;

begin
    reset <= not i_resetBar;
    continue_cnt <= '0' when cnt = "000" else '1';

    dFF_20: dFF_2 port map(i_d => reset, i_clock => i_clock, o_q => s0, o_qBar => s0_bar);
    dFF_21: dFF_2 port map(i_d => s0_bar and i_A(3), i_clock => i_clock, o_q => s1, o_qBar => s1_bar);
    dFF_22: dFF_2 port map(i_d => s0_bar and i_B(3), i_clock => i_clock, o_q => s2, o_qBar => s2_bar);
    dFF_23: dFF_2 port map(i_d => s0_bar and s4_bar and s5_bar, i_clock => i_clock, o_q => s3, o_qBar => s3_bar);
    dFF_24: dFF_2 port map(i_d => s3_bar and i_bit0 and continue_cnt, i_clock => i_clock, o_q => s4, o_qBar => s4_bar);
    dFF_25: dFF_2 port map(i_d => (s3_bar and not i_bit0 and continue_cnt) or s4_bar, i_clock => i_clock, o_q => s5, o_qBar => s5_bar);

    o_compA <= s1;
    o_compB <= s2;
    o_load_FA <= s1 or s3;
    o_load_FB <= s2 or s3;
    o_load_product <= s4;
    o_shift_left_A <= s5;
    o_shift_right_B <= s5;

    process(i_clock)
    begin
        if rising_edge(i_clock) then
            if s0 = '1' then
                cnt <= to_unsigned(4, 3);
            elsif s5 = '1' then
                cnt <= cnt - 1;
            end if;
        end if;
    end process;
end rtl;