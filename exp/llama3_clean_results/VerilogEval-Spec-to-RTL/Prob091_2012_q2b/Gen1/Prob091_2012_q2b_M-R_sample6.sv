module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assign Y1 based on the transition from A to B
assign Y1 = (y[0] && w);

// Assign Y3 based on the transitions to D
assign Y3 = (y[1] &&!w) || (y[2] &&!w) || (y[4] &&!w) || (y[5] &&!w) || (y[3] &&!w);

endmodule