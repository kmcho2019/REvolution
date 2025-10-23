module TopModule(
    input  [5:0] y,  // current state one-hot encoding: A=y[0], B=y[1], ..., F=y[5]
    input        w,
    output       Y2, // next state bit for B (y[1])
    output       Y4  // next state bit for D (y[3])
);

    assign Y2 = y[0] & ~w;
    assign Y4 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule