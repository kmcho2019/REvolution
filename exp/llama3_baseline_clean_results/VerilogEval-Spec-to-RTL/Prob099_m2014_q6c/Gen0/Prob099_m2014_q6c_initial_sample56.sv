module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// One-hot encoding for states A to F
// A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Logic equation for Y2 (y[1]) which corresponds to state B
assign Y2 = (y[0] && !w) || (y[3] && !w);

// Logic equation for Y4 (y[3]) which corresponds to state D
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w) || (y[5] && !w);

endmodule