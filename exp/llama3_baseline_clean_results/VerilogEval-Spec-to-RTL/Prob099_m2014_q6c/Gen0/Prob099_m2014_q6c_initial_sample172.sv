module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Logic equation for Y1 (y[1])
assign Y1 = y[0] & ~w;

// Logic equation for Y3 (y[3])
assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w);

endmodule