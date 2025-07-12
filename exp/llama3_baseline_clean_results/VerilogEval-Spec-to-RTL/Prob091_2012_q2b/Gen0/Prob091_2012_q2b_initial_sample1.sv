module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Determine the next state for Y1
assign Y1 = (y[1] &&!w) || (y[0] && w);

// Determine the next state for Y3
assign Y3 = (y[1] && w) || (y[2] && w);

endmodule