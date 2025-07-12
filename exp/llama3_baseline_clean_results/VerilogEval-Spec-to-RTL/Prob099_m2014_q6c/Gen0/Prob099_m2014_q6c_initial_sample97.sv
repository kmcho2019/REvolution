module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A to F: 000001, 000010, 000100, 001000, 010000, 100000
// y[5:0] corresponds to states F to A respectively in one-hot encoding

// Logic equation for Y1 (next-state signal for state A, y[0])
// Transition to A from D when w = 1
assign Y1 = y[3] & w;

// Logic equation for Y3 (next-state signal for state C, y[2])
// Transition to C from F when w = 0
assign Y3 = y[5] & ~w;

endmodule