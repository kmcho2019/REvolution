module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoded states: A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Next-state signal Y1 (y[1]) is 1 when next state is B
assign Y1 = (y[0] && w) || (y[3] && ~w);

// Next-state signal Y3 (y[3]) is 1 when next state is D
assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[3] && w);

endmodule