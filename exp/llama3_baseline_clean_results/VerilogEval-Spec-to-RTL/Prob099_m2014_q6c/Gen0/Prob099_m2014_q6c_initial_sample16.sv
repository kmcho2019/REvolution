module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// One-hot encoding for states A to F
// A: 000001, B: 000010, C: 000100, D: 001000, E: 010000, F: 100000

// Next-state logic for Y1 (y[0]) - State A
assign Y1 = (y[3] & w); // D -> A when w = 1

// Next-state logic for Y3 (y[2]) - State C
assign Y3 = (y[1] & ~w) | (y[5] & w); // B -> C when w = 0, F -> C when w = 1

endmodule