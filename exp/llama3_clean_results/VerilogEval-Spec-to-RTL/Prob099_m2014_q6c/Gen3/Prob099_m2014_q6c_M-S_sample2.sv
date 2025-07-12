module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Simplified logic equations for Y1 and Y3 based on one-hot encoding
assign Y1 = (y[0] & ~w) | (y[3] & w);
assign Y3 = (y[1] & ~w) | (y[2] & w) | (y[4] & w);

endmodule