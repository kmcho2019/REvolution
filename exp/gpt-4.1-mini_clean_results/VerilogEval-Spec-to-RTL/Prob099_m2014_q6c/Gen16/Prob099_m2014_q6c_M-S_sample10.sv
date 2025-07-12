module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit for B (y[1])
    output       Y3  // next state bit for D (y[3])
);

    // Y1 = 1 when next state is B, which happens only from A with w=0
    assign Y1 = y[0] & ~w;

    // Y3 = 1 when next state is D, which happens from B,C,D,E,F when w=1
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule