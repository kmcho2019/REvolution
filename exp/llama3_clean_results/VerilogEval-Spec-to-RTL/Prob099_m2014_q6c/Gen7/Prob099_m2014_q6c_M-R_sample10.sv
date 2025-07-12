module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = (y[0] && !w); // Next state B
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && !w); // Next state D

endmodule