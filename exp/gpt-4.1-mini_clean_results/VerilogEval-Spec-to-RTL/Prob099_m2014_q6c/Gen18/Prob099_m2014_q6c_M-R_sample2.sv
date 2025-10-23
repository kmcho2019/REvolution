module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit corresponding to B (y[1])
    output       Y3  // next state bit corresponding to D (y[3])
);

    // Next state B (y[1]) occurs only when current state A (y[0]) and input w=0
    assign Y1 = y[0] & ~w;

    // Next state D (y[3]) occurs when input w=1 and current state in {B,C,D,E,F}
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule