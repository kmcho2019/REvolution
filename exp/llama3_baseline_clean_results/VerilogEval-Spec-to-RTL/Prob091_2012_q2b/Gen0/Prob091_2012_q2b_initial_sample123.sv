module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 is set in states B and D when w is 1, and in states E and F when w is 0
assign Y1 = (y[1] & w) | (y[5] & ~w) | (y[3] & w);

// Y3 is set in state D
assign Y3 = (y[3] & w);

endmodule