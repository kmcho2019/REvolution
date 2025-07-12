module TopModule(
    input  [5:0] y,   // one-hot state encoding: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,  // next-state bit corresponding to state B (y[1])
    output       Y3   // next-state bit corresponding to state D (y[3])
);

    // Next state logic for B (y[1]):
    // B is next when current state is A and input w=0
    wire next_B = y[0] & ~w;

    // Next state logic for D (y[3]):
    // D is next from B, C, E, or F states when w=1
    wire next_D = w & (y[1] | y[2] | y[4] | y[5]);

    assign Y1 = next_B;
    assign Y3 = next_D;

endmodule