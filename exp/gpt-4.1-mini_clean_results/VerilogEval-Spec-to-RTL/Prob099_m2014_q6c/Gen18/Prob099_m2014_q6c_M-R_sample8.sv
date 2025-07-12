module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit for B (y[1])
    output       Y3  // next state bit for D (y[3])
);

    // From the state transitions given:
    // Y1 (next B) = (state A & ~w) | (state C & ~w) | (state F & ~w)
    //   Because:
    //     A->B if w=0
    //     C->E or D (so no B here directly), but C->E and C->D, no B from C on 0 or 1
    //     Actually, from C:
    //       C (0)->E, C (1)->D, no B
    //     From F:
    //       F (0)->C, F (1)->D, no B
    //
    // Let's re-derive carefully:
    // States transitions for B (y[1]) next:
    //   A --0--> B   => Y1 = y[0]&~w
    //   B --?--> ?   no transition to B
    //   C --?--> ?   no B transition
    //   D --?--> ?   no B transition
    //   E --?--> ?   no B transition
    //   F --?--> ?   no B transition
    //
    // So Y1 = y[0] & ~w
    //
    // For Y3 (next D):
    // States with next D transitions:
    //   B --1--> D
    //   C --1--> D
    //   D --1--> A (no)
    //   E --1--> D
    //   F --1--> D
    //   A --1--> A (no)
    //
    // So Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w)
    //
    // Final equations:
    //   Y1 = y[0] & ~w
    //   Y3 = w & (y[1] | y[2] | y[4] | y[5])

    assign Y1 = y[0] & ~w;
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule