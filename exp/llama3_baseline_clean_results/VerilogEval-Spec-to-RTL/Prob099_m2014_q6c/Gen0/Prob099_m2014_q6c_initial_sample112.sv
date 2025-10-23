module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state signal Y2 (y[1])
assign Y2 = (y[0] & w) | y[1] | (y[4] & w) | (y[5] & ~w);

// Next-state signal Y4 (y[3])
assign Y4 = y[3] | (y[0] & ~w) | (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

// Assigning Y1 and Y3
assign Y1 = y[0];
assign Y3 = y[2];

endmodule