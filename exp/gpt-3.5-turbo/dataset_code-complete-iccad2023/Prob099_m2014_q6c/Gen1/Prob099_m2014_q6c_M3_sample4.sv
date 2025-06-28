module TopModule (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

assign Y2 = (y[4] & ~w) | (y[5] & w);
assign Y4 = (y[5] & ~w) | (y[3] & w);

endmodule