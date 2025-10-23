module TopModule(
    input  [5:0] y,  // current state one-hot encoding
    input        w,
    output       Y2, // next state bit for y[1] (state B)
    output       Y4  // next state bit for y[3] (state D)
);

assign Y2 = y[0] & (~w);
assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule