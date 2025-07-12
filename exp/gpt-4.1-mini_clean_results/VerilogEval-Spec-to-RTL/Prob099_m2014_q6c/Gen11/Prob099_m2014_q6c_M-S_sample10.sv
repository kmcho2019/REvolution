module TopModule (
    input  [5:0] y,  // states: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next B state
    output       Y3  // next D state
);

    assign Y1 = y[0] & ~w;
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule