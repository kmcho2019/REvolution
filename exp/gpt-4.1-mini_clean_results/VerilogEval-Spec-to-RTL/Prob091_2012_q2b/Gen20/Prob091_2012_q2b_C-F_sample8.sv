module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Invert w once for reuse
    wire w_n = ~w;

    // Y1: input to state B flip-flop
    // Transition: A (y[0]) --1--> B, so Y1 = y[0] & w
    assign Y1 = y[0] & w;

    // Y3: input to state D flip-flop
    // Transitions to D from B,C,E,F on w=0
    // Equivalent to Y3 = ~w & (y[1] | y[2] | y[4] | y[5])
    // Because one-hot encoding means only one bit is set,
    // this is equivalent to Y3 = ~w & ~(y[0] | y[3])
    assign Y3 = w_n & ~(y[0] | y[3]);

endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Instantiate combinational next-state logic
    NextStateInput next_state (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule