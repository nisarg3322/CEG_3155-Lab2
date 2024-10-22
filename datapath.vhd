library ieee;
use ieee.std_logic_1164.all;

entity datapath is
    port(
        i_resetBar :  in std_logic;
        i_A, i_B : in std_logic_vector(3 downto 0);
        i_load_product, i_compA, i_compB, i_load_FA, i_load_FB, i_shift_right_B, i_shift_left_A : in std_logic;
        i_clock : in std_logic;
        o_Value : out std_logic_vector(7 downto 0);
        o_ValueB : out std_logic);
end datapath;

architecture rtl of datapath is
   
    
    component eightBitLeftShiftRegister
        port(
            i_resetBar, i_load : in std_logic;
            i_enable : in std_logic;
            i_clock : in std_logic;
            i_Value : in std_logic_vector(7 downto 0);
            o_Value : out std_logic_vector(7 downto 0)
        );
    end component;

    component eightBitRightShiftRegister
        port(
            i_resetBar, i_load : in std_logic;
                        i_enable : in std_logic;
            i_clock : in std_logic;
            i_Value : in std_logic_vector(7 downto 0);
            o_Value : out std_logic_vector(7 downto 0)
        );
    end component;

    component eightBitAdder
        port(
            i_Ai, i_Bi		: in	std_logic_vector(7 downto 0);
            i_CarryIn		: in	std_logic;
            o_CarryOut		: out	std_logic;
            o_Sum			: out	std_logic_vector(7 downto 0));
    end component;

    component eightBitRegister
        port(
            i_resetBar, i_load : in std_logic;
            i_clock : in std_logic;
            i_Value : in std_logic_vector(7 downto 0);
            o_Value : out std_logic_vector(7 downto 0)
        );
    end component;

    component mux1to2_4bit is
        port(
            sel : in std_logic;
            d0, d1 : in std_logic_vector(3 downto 0);
            y : out std_logic_vector(3 downto 0)
        );
    end component;

    component mux1to2_8bit is
        port(
            sel : in std_logic;
            d0, d1 : in std_logic_vector(7 downto 0);
            y : out std_logic_vector(7 downto 0)
        );
    end component;

    signal int_ValueMuxOut : std_logic_vector(7 downto 0);
    signal int_ValueA, int_ValueB : std_logic_vector(7 downto 0);
    signal int_ValueProduct : std_logic_vector(7 downto 0);
    signal int_ValueFA, int_ValueFB : std_logic_vector(7 downto 0);
    signal int_ValueShiftRightB, int_ValueShiftLeftA : std_logic_vector(7 downto 0);
    signal int_ValueAdd : std_logic_vector(7 downto 0);
    signal int_ValueCompProduct : std_logic_vector(7 downto 0);
    signal int_ValueCompA, int_ValueCompB : std_logic_vector(3 downto 0);
    signal int_ValueOutA , int_ValueOutB: std_logic_vector(7 downto 0);
    signal int_ValueMuxOutA : std_logic_vector(7 downto 0);
    signal o_CarryOut : std_logic;
begin
    
    CompA: entity work.twosComplementer
    GENERIC MAP (N => 4)
    PORT MAP (
        i_Value => i_A,
        o_Value => int_ValueCompA
    );

    CompB: entity work.twosComplementer
    GENERIC MAP (N => 4)
    PORT MAP (
        i_Value => i_B,
        o_Value => int_ValueCompB
    );

    mux1to2_CompA: mux1to2_4bit
    PORT MAP (
        sel => i_A(3),
        d0 => i_A,
        d1 => int_ValueCompA,
        y => int_ValueA(3 downto 0)
    );

    mux1to2_CompB: mux1to2_4bit
    PORT MAP (
        sel => i_B(3),
        d0 => i_B,
        d1 => int_ValueCompB,
        y => int_ValueB(3 downto 0)
    );


    FA: eightBitLeftShiftRegister
    PORT MAP (
        i_resetBar => i_resetBar,
        i_load => i_load_FA,
        i_enable => i_shift_left_A,
        i_clock => i_clock,
        i_Value => int_ValueA,
        o_Value => int_ValueFA
    );

    adder: eightBitAdder
    port map(
        i_Ai => int_ValueFA,
        i_Bi => int_ValueProduct,
        o_Sum => int_ValueAdd,
        i_CarryIn => '0',
        o_CarryOut => o_CarryOut
    );

    product_reg: eightBitRegister
    port map(
        i_resetBar => i_resetBar,
        i_load => i_load_product,
        i_clock => i_clock,
        i_Value => int_ValueAdd,
        o_Value => int_ValueProduct
    );

    product_2comp_reg: entity work.twosComplementer
    GENERIC MAP (N => 8)
    PORT MAP (
        i_Value => int_ValueProduct,
        o_Value => int_ValueCompProduct
    );

    mux1to2_CompProduct: mux1to2_8bit
    PORT MAP (
        sel => i_A(3) XOR i_B(3),
        d0 => int_ValueProduct,
        d1 => int_ValueCompProduct,
        y => int_ValueMuxOut
    );

    -- logic for sending B(i) value to control unit

    FB: eightBitRightShiftRegister
    PORT MAP (
        i_resetBar => i_resetBar,
        i_load => i_load_FB,
        i_enable => i_shift_right_B,
        i_clock => i_clock,
        i_Value => int_ValueB,
        o_Value => int_ValueFB
    );

    o_ValueB <= int_ValueFB(0);
    o_Value <= int_ValueMuxOut;
    end rtl;