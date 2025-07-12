module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Y1 corresponds to state B and can be reached from state A when w is 0
    assign Y1 = ~w & y[0];

    // Y3 corresponds to state D and can be reached from states B, C, E, and F under specific conditions
    // From the state machine, we see:
    // - B to D when w is 0
    // - C to D when w is 0
    // - E to D when w is 0
    // - F to D when w is 0
    // - Also, consider transitions from other states to D based on the machine's definition
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule