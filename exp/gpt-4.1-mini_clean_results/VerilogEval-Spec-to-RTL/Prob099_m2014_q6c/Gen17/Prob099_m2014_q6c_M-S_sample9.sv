module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit corresponding to y[1] (state B)
    output       Y3  // next state bit corresponding to y[3] (state D)
);

    // Y1 is high when next state is B:
    // from A to B when w=0, so Y1 = y[0] & ~w
    assign Y1 = y[0] & ~w;

    // Y3 is high when next state is D:
    // D can be reached from B,C,D,E,F when w=1,
    // so Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5])
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule