module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = (y[5] & ~w) | (y[1] & w) | (y[3] & ~w);
assign Y3 = (y[1] & ~w) | (y[5] & w);

endmodule