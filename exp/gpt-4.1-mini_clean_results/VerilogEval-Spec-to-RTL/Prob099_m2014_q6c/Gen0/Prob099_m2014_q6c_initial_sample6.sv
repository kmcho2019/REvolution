module TopModule(
    input  [5:0] y,  // current state one-hot
    input        w,
    output       Y1, // next y[1]
    output       Y3  // next y[3]
);

assign Y1 = y[0] & (~w);
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule