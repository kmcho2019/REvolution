module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assign Y1 based on the transition from A to B
assign Y1 = y[0] && w;

// Assign Y3 based on the transitions to D
assign Y3 = (!w && (y[1] || y[2] || y[4] || y[5] || y[3]));

endmodule