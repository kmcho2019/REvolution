module TopModule(
    input [2:0] y,  // current state
    input w,
    output Y1       // next state's y[1]
);

// Next state logic for y[1]
// If the current state is A (000) or B (001) and w is 1, y[1] will be 0 in the next state
// If the current state is A (000) or B (001) and w is 0, we move to B (001) or C (010) respectively, y[1] will be 0 or 1
// If the current state is C (010) or D (011) and w is 0, we move to E (100) or F (101) but since we are only implementing y[1], 
// we look at the states C (010), D (011), E (100), and F (101), for which y[1] will be 1 in the next state if the next state is D (011) or F (101)
// If the current state is E (100), y[1] will be 0 in the next state because E (100) has y[1] as 0
// If the current state is F (101), y[1] will be 1 if w is 1 and 0 if w is 0

// Based on the given state machine, the conditions where y[1] is 1 in the next state are:
// 1. Current state is A (000) and w is 0 (next state is C)
// 2. Current state is B (001) and w is 0 (next state is C)
// 3. Current state is C (010) and w is 1 (next state is D)
// 4. Current state is D (011) and w is 1 (next state is A but y[1] is 0) or w is 0 (next state is F but y[1] is 1)
// 5. Current state is E (100) and w is 1 (next state is D)
// 6. Current state is F (101) and w is 0 (next state is C)

assign Y1 = (y == 3'b000 && ~w) || (y == 3'b001 && ~w) || (y == 3'b010 && w) || (y == 3'b011 && ~w) || (y == 3'b100 && w) || (y == 3'b101 && ~w);

endmodule