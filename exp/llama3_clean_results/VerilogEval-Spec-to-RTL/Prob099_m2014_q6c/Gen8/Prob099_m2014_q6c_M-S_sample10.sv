module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Next state B (Y1)
assign Y1 = (y[0] && !w) || (y[2] && w) || (y[5] && w);

// Next state D (Y3)
assign Y3 = (y[1] && w) || (y[2] && !w) || (y[3] && !w) || (y[4] && w) || (y[5] && !w);

// Next state C (Y2)
assign Y2 = (y[1] && !w) || (y[4] && !w);

// Next state F (Y4)
assign Y4 = (y[3] && w);

endmodule