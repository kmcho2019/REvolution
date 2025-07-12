module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

// Next-state logic for Y1 (A)
assign Y1 = (y[0] && !w) || (y[3] && w);

// Next-state logic for Y3 (C)
assign Y3 = (y[1] && !w) || (y[5] && !w);

endmodule