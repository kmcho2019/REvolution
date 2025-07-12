module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next state B (Y1) 
assign Y1 = (y[5] && w) || (y[3] && w) || (y[1] &&!w);

// Next state D (Y3)
assign Y3 = (y[2] && w) || (y[3] &&!w) || (y[4] && w) || (y[5] &&!w);

endmodule