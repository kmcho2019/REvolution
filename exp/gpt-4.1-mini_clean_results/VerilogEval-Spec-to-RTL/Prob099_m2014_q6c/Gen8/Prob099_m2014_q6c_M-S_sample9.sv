module TopModule (
    input  [5:0] y,  // current one-hot state
    input        w,
    output       Y2, // next-state signal for y[1] (B)
    output       Y4  // next-state signal for y[3] (D)
);

assign Y2 = y[0] & ~w;
assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule