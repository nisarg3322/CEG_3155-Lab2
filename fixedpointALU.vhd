library ieee;
use ieee.std_logic_1164.all;

entity fixedpointALU is
    port(
        i_reset : in std_logic;
        i_clock : in std_logic;
        i_operandA, i_operandB : in std_logic_vector(3 downto 0);
        i_operationselect : in std_logic_vector(1 downto 0);
        o_Value : out std_logic_vector(7 downto 0);
        o_CarryOut : out std_logic;
        o_zeroout : out std_logic;
        o_overflow : out std_logic);
end fixedpointALU;

architecture rtl of fixedpointALU is
    component fourbitadderandsubtractor is
        port(
            i_Ai, i_Bi : in std_logic_vector(3 downto 0);
            i_add_subtract : in std_logic;
            o_CarryOut : out std_logic;
            o_Sum : out std_logic_vector(3 downto 0));
    end component;

    component shiftandaddmultiplier is
        port(
            i_A, i_B : in std_logic_vector(3 downto 0);
            i_resetBar : in std_logic;
            i_clock : in std_logic;
            o_Value : out std_logic_vector(7 downto 0)
            );
    end component;

    component mux2to4 is
        port(
            sel : in std_logic_vector(1 downto 0);
            d0, d1, d2, d3 : in std_logic_vector(7 downto 0);
            y : out std_logic_vector(7 downto 0));
    end component;

    component mux2to41bit is
        port(
            sel : in std_logic_vector(1 downto 0);
            d0, d1, d2, d3 : in std_logic;
            y : out std_logic);
    end component;

    signal  d0_result, d1_result, d2_result, d3_result, final_result : std_logic_vector(7 downto 0);
    signal d0_carryout, d1_carryout, d2_carryout, d3_carryout, carryout : std_logic;
    signal zeroout : std_logic;
    signal overflow ,i_resetBar : std_logic;

begin

    i_resetBar <= not i_reset;
    adder_inst: fourbitadderandsubtractor 
        port map(
        i_Ai => i_operandA,
        i_Bi => i_operandB,
        i_add_subtract => '0',
        o_CarryOut => d0_carryout,
        o_Sum => d0_result(3 downto 0));

    substracter_inst: fourbitadderandsubtractor 
        port map(
        i_Ai => i_operandA,
        i_Bi => i_operandB,
        i_add_subtract => '1',
        o_CarryOut => d1_carryout,
        o_Sum => d1_result(3 downto 0));

    multiplier_inst: shiftandaddmultiplier
        port map(
        i_A => i_operandA,
        i_B => i_operandB,
        i_resetBar => i_resetBar,
        i_clock => i_clock,
        o_Value => d2_result
        );
    
    mux_inst: mux2to4 
        port map(
        sel => i_operationselect,
        d0 => d0_result,
        d1 => d1_result,
        d2 => d2_result,
        d3 => "00000000",
        y => final_result);
 muxcarry_inst: mux2to41bit 
        port map(
        sel => i_operationselect,
        d0 => d0_carryout,
        d1 => d1_carryout,
        d2 => '0',
        d3 => '0',
        y => carryout);
    o_Value <= final_result;
    o_zeroout <= '1' when final_result = "00000000" else '0';
    o_CarryOut <= carryout;
    end rtl;