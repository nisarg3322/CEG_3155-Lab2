library ieee;
use ieee.std_logic_1164.all;

entity shiftandaddmultiplier is
    port(
        i_A, i_B : in std_logic_vector(3 downto 0);
        i_resetBar : in std_logic;
        i_clock : in std_logic;
        o_Value : out std_logic_vector(7 downto 0));
end shiftandaddmultiplier;

architecture rtl of shiftandaddmultiplier is
    signal int_ValueB : std_logic;
    signal int_outputValue : std_logic_vector(7 downto 0);
    signal int_CarryOut : std_logic;
    signal i_load_product, i_compA, i_compB, i_load_FA, i_load_FB, i_shift_right_B, i_shift_left_A : std_logic;


    component datapath
        port(
            i_resetBar :  in std_logic;
            i_A, i_B : in std_logic_vector(3 downto 0);
            i_load_product, i_compA, i_compB, i_load_FA, i_load_FB, i_shift_right_B, i_shift_left_A : in std_logic;
            i_clock : in std_logic;
            o_Value : out std_logic_vector(7 downto 0);
            o_ValueB : out std_logic);
    end component;

    component controlpath
        port(
            i_bit0 : in std_logic;
            i_A, i_B : in std_logic_vector(3 downto 0);
            i_resetBar : in std_logic;
            i_clock : in std_logic;
            o_compA, o_compB, o_load_FA, o_load_FB, o_load_product, o_shift_left_A, o_shift_right_B : out std_logic);
    end component;

    begin
        
        controlpath_inst: controlpath port map(
            i_bit0 => int_ValueB,
            i_A => i_A,
            i_B => i_B,
            i_resetBar => i_resetBar,
            i_clock => i_clock,
            o_compA => i_compA,
            o_compB => i_compB,
            o_load_FA => i_load_FA,
            o_load_FB => i_load_FB,
            o_load_product => i_load_product,
            o_shift_left_A => i_shift_left_A,
            o_shift_right_B => i_shift_right_B
        );

        datapath_inst: datapath port map(
            i_resetBar => i_resetBar,
            i_A => i_A,
            i_B => i_B,
            i_load_product => i_load_product,
            i_compA => i_compA,
            i_compB => i_compB,
            i_load_FA => i_load_FA,
            i_load_FB => i_load_FB,
            i_shift_right_B => i_shift_right_B,
            i_shift_left_A => i_shift_left_A,
            i_clock => i_clock,
            o_Value => int_outputValue,
            o_ValueB => int_ValueB
        );

        o_Value <= int_outputValue;
        

        end rtl;