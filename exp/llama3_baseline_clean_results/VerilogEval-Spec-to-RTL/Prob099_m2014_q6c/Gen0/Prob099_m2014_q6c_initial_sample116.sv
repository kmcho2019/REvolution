module TopModule(
    input  [5:0] y, // Current state
    input  w,      // Input to determine next state
    output Y2,     // Next state B
    output Y4      // Next state D
);

// State A: 000001, State B: 000010, State C: 000100, State D: 001000, State E: 010000, State F: 100000

// Y2 (next state B) is true when in state A and w=1
assign Y2 = y[0] & w; // A and w=1

// Y4 (next state D) is true when in states B, C, E, F, or D and w=1
assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w; // B, C, E, or F and w=1, note: D's transition to itself doesn't need special handling here

endmodule