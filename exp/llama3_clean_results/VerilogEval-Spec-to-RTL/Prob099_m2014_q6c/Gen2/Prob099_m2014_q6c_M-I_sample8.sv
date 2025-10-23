module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

// Corrected logic equations for Y2 and Y4 based on one-hot encoding
assign Y2 = (y[0] & w) | (y[3] & ~w) | (y[4] & ~w);
assign Y4 = (y[1] & w) | (y[2] & ~w);

endmodule