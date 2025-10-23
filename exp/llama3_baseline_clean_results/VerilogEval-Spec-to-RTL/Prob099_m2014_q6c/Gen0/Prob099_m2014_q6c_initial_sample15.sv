module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states
// A: 000001, B: 000010, C: 000100, D: 001000, E: 010000, F: 100000

// Next-state signal Y2 (y[1]) is set when current state is B
assign Y2 = (y[0] && w) || (y[2] && w) || (y[3] && ~w);

// Next-state signal Y4 (y[3]) is set when current state is D
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

// Output Y1 and Y3 are assigned directly from y
assign Y1 = y[0];
assign Y3 = y[2];

endmodule