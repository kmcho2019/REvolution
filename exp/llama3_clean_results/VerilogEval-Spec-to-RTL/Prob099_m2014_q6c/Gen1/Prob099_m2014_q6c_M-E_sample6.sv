module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// One-hot encoding: A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Truth table for Y1 (state B)
assign Y1 = (y[0] & ~w) | (y[2] & ~w) | (y[4] & ~w);

// Truth table for Y2 (state C)
assign Y2 = (y[1] & ~w) | (y[3] & ~w) | (y[5] & w);

// Truth table for Y3 (state D)
assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

// Truth table for Y4 (state E)
assign Y4 = (y[2] & w) | (y[3] & ~w) | (y[5] & ~w);

endmodule