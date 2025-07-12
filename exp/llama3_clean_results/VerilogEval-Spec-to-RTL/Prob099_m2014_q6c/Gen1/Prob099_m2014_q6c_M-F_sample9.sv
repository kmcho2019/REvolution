module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// One-hot encoding: A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Y1 (state B) is set to 1 when the current state is A and w is 0
assign Y1 = (y[0] & ~w);

// Y2 (state C) is set to 1 when the current state is B and w is 0, or when the current state is F and w is 0
assign Y2 = (y[1] & ~w) | (y[5] & ~w);

// Y3 (state D) is set to 1 when the current state is B and w is 1, 
// or when the current state is C and w is 1, or when the current state is F and w is 1, 
// or when the current state is E and the input w is 1
assign Y3 = (y[1] & w) | (y[2] & w) | (y[5] & w) | (y[4] & w);

// Y4 (state E) is set to 1 when the current state is D and the input w is 0, 
// or when the current state is E and the input w is 1
assign Y4 = (y[3] & ~w) | (y[4] & w);

endmodule