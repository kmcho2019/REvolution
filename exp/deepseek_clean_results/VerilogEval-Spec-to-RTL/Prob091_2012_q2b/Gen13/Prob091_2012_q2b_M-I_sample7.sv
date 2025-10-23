module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Transition occurs only from state A (y[0]=1) when w=1 (A→B)
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transitions to D occur when:
    // - w=0 AND
    // - Current state is B(y[1]), C(y[2]), E(y[4]), or F(y[5])
    // Optimized implementation using explicit OR of relevant states
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule