module TopModule (
    input  [5:0] y,
    input        w,
    output       Y2,
    output       Y4
);

// Next state C (y[2]) is from:
// B(1) & ~w
// F(5) & ~w
assign Y2 = (~w) & (y[1] | y[5]);

// Next state D (y[3]) is from:
// B(1) & w
// C(2) & w
// E(4) & w
// F(5) & w
assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule