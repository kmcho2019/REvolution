module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next-state bit for B (y[1])
    output       Y3  // next-state bit for D (y[3])
);

    // From the FSM transitions:

    // Y1 (next state B, y[1]) occurs when:
    // - From A (y[0]) with w=0 --> next is B
    // So:
    // Y1 = y[0] & ~w

    // Y3 (next state D, y[3]) occurs when:
    // - From B (y[1]) with w=1
    // - From C (y[2]) with w=1
    // - From D (y[3]) with w=1
    // - From E (y[4]) with w=1
    // - From F (y[5]) with w=1
    //
    // So:
    // Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5])

    assign Y1 = y[0] & ~w;
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule