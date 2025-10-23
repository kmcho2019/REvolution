module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is 1 in states B and D
assign Y1 = (y[1] & w) | (y[3] & ~w);

// Y3 is 1 in state D
assign Y3 = y[3];

endmodule