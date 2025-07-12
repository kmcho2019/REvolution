module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2, // next state bit corresponding to B (y[1])
    output       Y4  // next state bit corresponding to D (y[3])
);

    // Next state B (y[1]) occurs only when current state A (y[0]) and w=0
    wire next_B = y[0] & ~w;

    // Next state D (y[3]) occurs when w=1 and current state is any of B, C, D, E, or F
    wire next_D = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

    assign Y2 = next_B;
    assign Y4 = next_D;

endmodule