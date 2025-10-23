module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Next state B
assign Y1 = (y[0] && !w) || (y[5] && w);

// Next state C
assign Y2 = (y[1] && !w) || (y[5] && !w);

// Next state D
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && !w) || (y[5] && w);

// Next state E
assign Y4 = (y[2] && !w);

endmodule