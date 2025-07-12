module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states: A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000
// Y1 corresponds to state A (y[0])
// Y3 corresponds to state C (y[2])

// Logic equation for Y1 (next state for A)
assign Y1 = (y[0] & w) | (y[3] & ~w);

// Logic equation for Y3 (next state for C)
assign Y3 = (y[1] & ~w) | (y[5] & w);

endmodule