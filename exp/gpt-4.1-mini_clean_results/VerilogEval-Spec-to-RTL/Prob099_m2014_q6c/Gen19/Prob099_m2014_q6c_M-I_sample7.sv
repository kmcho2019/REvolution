module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2, // next state bit corresponding to B (y[1])
    output       Y4  // next state bit corresponding to D (y[3])
);

    // Next state B (y[1]) occurs only from:
    // A --0--> B  => y[0] & ~w
    assign Y2 = y[0] & ~w;

    // Next state D (y[3]) occurs from multiple transitions with w=1:
    // B --1--> D : y[1] & w
    // C --1--> D : y[2] & w
    // E --1--> D : y[4] & w
    // F --1--> D : y[5] & w
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule