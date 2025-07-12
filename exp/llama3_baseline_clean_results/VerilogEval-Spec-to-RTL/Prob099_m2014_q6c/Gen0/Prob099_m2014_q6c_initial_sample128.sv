module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state logic for Y2 (state B)
assign Y2 = (y[0] && !w) || (y[4] && !w) || (y[5] && !w);

// Next-state logic for Y4 (state D)
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && w) || (y[4] && w);

// Output assignment for Y1 (since not used in the problem description)
assign Y1 = 1'b0;

endmodule