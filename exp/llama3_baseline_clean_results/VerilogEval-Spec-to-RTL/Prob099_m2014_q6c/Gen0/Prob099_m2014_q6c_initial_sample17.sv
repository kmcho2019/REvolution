module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assigning Y1 and Y3 directly from y for simplicity
assign Y1 = y[0];
assign Y3 = y[2];

// Next-state logic for Y2 (state B)
assign Y2 = (y[0] && w);

// Next-state logic for Y4 (state D)
assign Y4 = ((y[1] || y[2] || y[4] || y[5]) && w);

endmodule