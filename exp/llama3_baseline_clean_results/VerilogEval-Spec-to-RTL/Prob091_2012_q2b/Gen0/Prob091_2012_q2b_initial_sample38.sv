module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next state logic for Y1 (y[1])
// Y1 is 1 in states B and D
assign Y1 = (y[1] && !w) || (y[0] && w) || (y[2] && !w) || (y[3] && !w) || (y[4] && !w) || (y[5] && w);

// Next state logic for Y3 (y[3])
// Y3 is 1 in state D
assign Y3 = (y[2] && !w) || (y[1] && !w) || (y[4] && !w) || (y[5] && w) || (y[0] && !w);

endmodule