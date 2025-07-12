module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// State A (000001) transitions
// Since y[0] is '1' in state A, check w to decide next state
// If w = 1, go to B (000010), so Y1 should be 1
// If w = 0, stay in A (000001), so Y1 and Y3 should be 0
// For all other states, Y1 and Y3 are 0 unless specified below

// State B (000010) transitions
// Since y[1] is '1' in state B, check w to decide next state
// If w = 1, go to C (000100), so Y3 should be 1
// If w = 0, go to D (001000), so Y3 should be 1

// State C (000100) transitions
// Since y[2] is '1' in state C, check w to decide next state
// If w = 1, stay in E is not possible, go to E (010000), but E has y[4] = 1, not Y3
// If w = 0, go to D (001000), so Y3 should be 1

// State D (001000) transitions
// Since y[3] is '1' in state D, check w to decide next state
// If w = 1, go to F (100000), so Y3 should be 0
// If w = 0, go to A (000001), so Y1 and Y3 should be 0

// State E (010000) transitions
// Since y[4] is '1' in state E, check w to decide next state
// If w = 1, stay in E (010000), so Y3 should be 0
// If w = 0, go to D (001000), so Y3 should be 1

// State F (100000) transitions
// Since y[5] is '1' in state F, check w to decide next state
// If w = 1, go to C (000100), so Y3 should be 1
// If w = 0, go to D (001000), so Y3 should be 1

// Implementation
assign Y1 = (y[0] && w);  // Go to B from A when w = 1
assign Y3 = (y[1] && w) || (y[2] && ~w) || (y[5] && w) || (y[3] && ~w) || (y[4] && ~w);

endmodule