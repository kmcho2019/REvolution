module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Transition: A->B when w=1 (y[0] is A in one-hot)
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transitions to D occur when:
    // - From B (y[1]) when w=0 OR
    // - From C (y[2]) when w=0 OR
    // - From E (y[4]) when w=0 OR
    // - From F (y[5]) when w=0
    // Optimized using one-hot property: ~(y[0] | y[3]) covers all cases
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule