module TopModule(
    input  [5:0] y,   // one-hot current state: A= y[0], B= y[1], C= y[2], D= y[3], E= y[4], F= y[5]
    input        w,
    output       Y1,  // next state's bit for B (y[1])
    output       Y3   // next state's bit for D (y[3])
);

    // From the state machine and next states:
    // Next y[1] (B) is '1' in next state for transitions:
    // A(0) --0--> B(1)   => if y[0] & ~w
    // No other transitions lead to B(1) next.

    // Next y[3] (D) is '1' in next state for transitions:
    // B(1) --1--> D(3)   => y[1] & w
    // C(2) --1--> D(3)   => y[2] & w
    // D(3) --1--> A(0)   => no (A= y[0], so no y[3])
    // E(4) --1--> D(3)   => y[4] & w
    // F(5) --1--> D(3)   => y[5] & w

    // Therefore:

    assign Y1 = y[0] & ~w;

    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule