module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Invert inputs once to minimize toggle and simplify logic
    wire w_n   = ~w;
    wire y0_n  = ~y[0];
    wire y3_n  = ~y[3];

    // Y1: next state input for state B (y[1])
    // Only transition to B: A (y[0]) --1--> B, i.e., y[0] & w
    assign Y1 = y[0] & w;

    // Y3: next state input for state D (y[3])
    // Transitions to D occur on w=0 from B,C,E,F,
    // which equals ~w & ~(y[0] | y[3]) under one-hot encoding.
    // De Morgan's form used here: ~w & ~y[0] & ~y[3]
    assign Y3 = w_n & y0_n & y3_n;

endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Instantiate the next state logic module
    NextStateInput next_state_inst (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule