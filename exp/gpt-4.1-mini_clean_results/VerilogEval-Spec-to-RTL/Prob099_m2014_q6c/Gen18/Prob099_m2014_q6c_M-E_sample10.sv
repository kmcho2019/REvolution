module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit corresponding to B (y[1])
    output       Y3  // next state bit corresponding to D (y[3])
);

    // Next state B (y[1]) occurs only from:
    // A --0--> B
    // So when current state is A (y[0]) and w=0
    assign Y1 = (y[0] & ~w);

    // Next state D (y[3]) occurs from multiple transitions:
    // B --1--> D  : y[1] & w
    // C --1--> D  : y[2] & w
    // D --1--> A  : y[3] & w  (but goes to A, so no)
    // E --1--> D  : y[4] & w
    // F --1--> D  : y[5] & w
    // So next D is high when w=1 and current state is one of B, C, E, F
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule