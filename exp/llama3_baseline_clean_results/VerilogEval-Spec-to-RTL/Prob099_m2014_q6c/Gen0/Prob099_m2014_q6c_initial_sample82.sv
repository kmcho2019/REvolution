module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoded states
// A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Next-state signal Y2 (y[1]) is '1' if the next state is B
// This happens if the current state is A and w is '0', or if the current state is D and w is '0'
assign Y2 = (y[0] && !w) || (y[3] && !w);

// Next-state signal Y4 (y[3]) is '1' if the next state is D
// This happens if the current state is B and w is '1', or if the current state is C and w is '1',
// or if the current state is E and w is '1', or if the current state is D and w is '1'
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[3] && w);

// Output Y1 is '1' if the current state is A
assign Y1 = y[0];

// Output Y3 is '1' if the current state is C
assign Y3 = y[2];

endmodule