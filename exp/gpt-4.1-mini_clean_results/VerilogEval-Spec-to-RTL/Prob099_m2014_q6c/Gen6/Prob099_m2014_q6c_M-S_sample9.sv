module TopModule (
    input  [5:0] y, // one-hot current state: A=000001 y[0], B=000010 y[1], etc.
    input        w,
    output       Y2, // next-state signal for y[1] (state B)
    output       Y4  // next-state signal for y[3] (state D)
);

assign Y2 = y[0] & ~w;
assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule