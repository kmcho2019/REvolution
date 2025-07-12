module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Y1: Next state input for state B (y[1])
    // Only transition to B: from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: Next state input for state D (y[3])
    // Transitions to D occur on w=0 from B, C, E, F
    // Using De Morgan's form for minimal logic and toggling:
    // Y3 = ~w & ~y[0] & ~y[3]
    // Equivalent to ~w & ~(y[0] | y[3]) but decomposed for simpler gates and less toggling
    assign Y3 = w_n & ~y[0] & ~y[3];

endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    NextStateInput next_state_inst (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

endmodule