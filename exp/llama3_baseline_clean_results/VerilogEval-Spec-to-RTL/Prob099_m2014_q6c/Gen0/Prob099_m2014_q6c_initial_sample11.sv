module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding: A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000
// Next-state signals Y2 and Y4 correspond to signal y[1] and y[3]
assign Y1 = y[0]; // State A
assign Y3 = y[2]; // State D

// Logic equations for next-state signals Y2 and Y4
// Y2 (y[1]) is set to 1 in states B and C
assign Y2 = (y[0] & w) | (y[1] & ~w) | (y[5] & w);

// Y4 (y[3]) is set to 1 in state D
assign Y4 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule