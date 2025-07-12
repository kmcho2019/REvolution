module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// For state A, y[0] = 1
// Next state for A is A (y[0] = 1) when w = 1, and B (y[1] = 1) when w = 0
// So, Y1 = y[0] (for A) and y[5] (for F)
assign Y1 = y[0] & ~w | y[5] & w;

// For state C, y[2] = 1
// Next state for C is E (y[4] = 1) when w = 1, and D (y[3] = 1) when w = 0
// So, Y3 = y[3] (for D) and y[4] (for E)
assign Y3 = y[3] & ~w | y[4] & w;

endmodule