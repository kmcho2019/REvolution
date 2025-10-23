module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Logic equation for Y1 (y[0])
assign Y1 = (y[0] & ~w) | (y[3] & w);

// Logic equation for Y3 (y[2])
assign Y3 = (y[1] & ~w) | (y[5] & w);

endmodule