module TopModule(
    input  [5:0] y,  // one-hot states: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit for y[1] (B)
    output       Y3  // next state bit for y[3] (D)
);

    assign Y1 = y[0] & ~w;           // Next B: from A on w=0
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]); // Next D: from B,C,D,E,F on w=1

endmodule