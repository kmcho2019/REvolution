module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = y[0] && w;  // Transition from A to B
assign Y3 = (~w) && (y[1] || y[2] || y[4] || y[5]);  // Transition to D from B, C, E, F

endmodule