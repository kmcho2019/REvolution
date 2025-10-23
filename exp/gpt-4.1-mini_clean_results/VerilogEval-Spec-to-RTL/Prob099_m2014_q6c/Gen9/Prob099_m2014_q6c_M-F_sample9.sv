module good1 (
    input  [5:0] y,  // current one-hot state (A=000001 ... F=100000)
    input        w,
    output       Y1, // next-state signal for y[1] (B)
    output       Y3  // next-state signal for y[3] (D)
);

assign Y1 = y[0] & ~w;
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule