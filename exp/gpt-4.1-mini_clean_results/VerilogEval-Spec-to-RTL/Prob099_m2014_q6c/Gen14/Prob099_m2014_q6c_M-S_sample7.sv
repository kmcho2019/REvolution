module TopModule (
    input  [5:0] y,  // current state one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2, // next state B
    output       Y4  // next state D
);

    assign Y2 = y[0] & ~w;
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule