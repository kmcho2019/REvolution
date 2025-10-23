module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 (y[0]) corresponds to state A
assign Y1 = (y[0] & ~w) | (y[3] & ~w);

// Y3 (y[2]) corresponds to state C
assign Y3 = (y[1] & ~w) | (y[5] & ~w);

endmodule