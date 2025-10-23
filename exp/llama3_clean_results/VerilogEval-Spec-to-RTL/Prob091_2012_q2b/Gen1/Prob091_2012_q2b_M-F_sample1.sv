module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = (y[0] && w) || (y[1] && !w); // A and w=1, or B and w=0
assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[5] && !w) || (y[3] && !w); // Transitions to D

endmodule