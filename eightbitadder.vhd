
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitAdder IS
	PORT(
		i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_CarryIn		: IN	STD_LOGIC;
		o_CarryOut		: OUT	STD_LOGIC;
		o_Sum			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitAdder;

ARCHITECTURE rtl OF eightBitAdder IS
	SIGNAL int_Sum, int_CarryOut : STD_LOGIC_VECTOR(7 downto 0);

	COMPONENT oneBitAdder
	PORT(
		i_CarryIn		: IN	STD_LOGIC;
		i_Ai, i_Bi		: IN	STD_LOGIC;
		o_Sum, o_CarryOut	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

add0: oneBitAdder
	PORT MAP (i_CarryIn => i_CarryIn, 
			  i_Ai => i_Ai(0),
			  i_Bi => i_Bi(0),
			  o_Sum => int_Sum(0),
			  o_CarryOut => int_CarryOut(0));

add1: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(0), 
			  i_Ai => i_Ai(1),
			  i_Bi => i_Bi(1),
			  o_Sum => int_Sum(1),
			  o_CarryOut => int_CarryOut(1));

add2: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(1), 
			  i_Ai => i_Ai(2),
			  i_Bi => i_Bi(2),
			  o_Sum => int_Sum(2),
			  o_CarryOut => int_CarryOut(2));

add3: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(2), 
			  i_Ai => i_Ai(3),
			  i_Bi => i_Bi(3),
			  o_Sum => int_Sum(3),
			  o_CarryOut => int_CarryOut(3));

add4: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(3), 
			  i_Ai => i_Ai(4),
			  i_Bi => i_Bi(4),
			  o_Sum => int_Sum(4),
			  o_CarryOut => int_CarryOut(4));

add5: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(4), 
			  i_Ai => i_Ai(5),
			  i_Bi => i_Bi(5),
			  o_Sum => int_Sum(5),
			  o_CarryOut => int_CarryOut(5));

add6: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(5), 
			  i_Ai => i_Ai(6),
			  i_Bi => i_Bi(6),
			  o_Sum => int_Sum(6),
			  o_CarryOut => int_CarryOut(6));

add7: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(6), 
			  i_Ai => i_Ai(7),
			  i_Bi => i_Bi(7),
			  o_Sum => int_Sum(7),
			  o_CarryOut => int_CarryOut(7));

	-- Output Driver
	o_Sum <= int_Sum;
	o_CarryOut <= int_CarryOut(7);

END rtl;
