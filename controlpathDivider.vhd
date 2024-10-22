library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlPath is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        start    : in  STD_LOGIC; -- Start division signal
        load     : out STD_LOGIC; -- Load signal to initialize the dividend
        shift    : out STD_LOGIC; -- Shift signal to shift remainder and dividend
        subtract : out STD_LOGIC; -- Subtract signal to subtract divisor from remainder
        done     : out STD_LOGIC  -- Division complete signal
    );
end ControlPath;

architecture Behavioral of ControlPath is
    signal counter    : INTEGER range 0 to 7 := 7; -- Counter for division iterations
    signal running    : STD_LOGIC := '0'; -- Flag to indicate running status
begin

    -- Control FSM (Finite State Machine)
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset all control signals and counter
            load <= '0';
            shift <= '0';
            subtract <= '0';
            done <= '0';
            running <= '0';
            counter <= 7;
        elsif rising_edge(clk) then
            if start = '1' then
                running <= '1';
                load <= '1'; -- Load the dividend
                shift <= '0';
                subtract <= '0';
                done <= '0';
            elsif running = '1' then
                if counter >= 0 then
                    load <= '0'; -- Stop loading after the first cycle
                    shift <= '1'; -- Shift the remainder and dividend
                    subtract <= '1'; -- Subtract if needed

                    counter <= counter - 1;

                    if counter < 0 then
                        shift <= '0';
                        subtract <= '0';
                        done <= '1'; -- Set done signal when division is complete
                        running <= '0'; -- Stop running
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
﻿
