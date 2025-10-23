module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Implement next-state signal Y1 (corresponding to y[0])
// This signal is high when the current state is A (y[0]) and w is 0,
// or when the current state is D (y[3]) and w is 0.
assign Y1 = (y[0] & ~w) | (y[3] & ~w);

// Implement next-state signal Y3 (corresponding to y[2])
// This signal is high when the current state is B (y[1]) and w is 1,
// or when the current state is C (y[2]) and w is 0,
// or when the current state is F (y[5]) and w is 0.
assign Y3 = (y[1] & w) | (y[2] & ~w) | (y[5] & ~w);

endmodule