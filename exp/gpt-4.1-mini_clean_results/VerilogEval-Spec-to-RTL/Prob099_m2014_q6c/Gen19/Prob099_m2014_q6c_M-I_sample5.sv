module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit for state B (y[1])
    output       Y3  // next state bit for state D (y[3])
);

    // Next-state bit for B: from A to B when w=0
    assign Y1 = y[0] & ~w;

    // Next-state bit for D: reached from B,C,D,E,F when w=1
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule