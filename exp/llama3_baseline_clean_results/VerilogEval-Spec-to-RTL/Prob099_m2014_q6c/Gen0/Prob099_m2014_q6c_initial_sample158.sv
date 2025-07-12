module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A to F: 000001, 000010, 000100, 001000, 010000, 100000
// Y1 corresponds to state A (y[0])
// Y3 corresponds to state C (y[2])

// Derive next-state logic for Y1 (state A)
assign Y1 = y[3] & w; // Next state is A when current state is D and w is 1

// Derive next-state logic for Y3 (state C)
assign Y3 = (y[1] & ~w) | (y[5] & w); // Next state is C when current state is B and w is 0, or when current state is F and w is 1

endmodule