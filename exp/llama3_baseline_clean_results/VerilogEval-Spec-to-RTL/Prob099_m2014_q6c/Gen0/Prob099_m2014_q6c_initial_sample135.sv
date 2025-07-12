module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// One-hot encoding for states A to F
// A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Deriving logic equations for Y2 (y[1]) and Y4 (y[3])
assign Y2 = (y[5] && !w) || (y[2] && !w) || (y[4] && w); // Y2 is set for state B and transitions to B
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && !w) || (y[5] && !w); // Y4 is set for state D and transitions to D

// Outputs Y1 and Y3
assign Y1 = y[0];
assign Y3 = y[3];

endmodule