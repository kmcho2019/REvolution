module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assign Y1 based on transitions to state B
assign Y1 = (y[0] && w) || (y[5] && w);

// Assign Y3 based on transitions to state D
assign Y3 = (!w && (y[1] || y[2] || y[4] || (y[3] && !w))) || (y[3] && w);

endmodule