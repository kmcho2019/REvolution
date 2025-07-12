module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Transition occurs only from state A (y[0]) when w=1
    // Optimal implementation: single AND gate
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transitions to D occur when w=0 and current state is not A or D
    // Optimized using De Morgan's law: ~(w | y[0] | y[3]) equivalent to original ~w & ~(y[0] | y[3])
    // Implementation uses just 1 OR and 1 NOT gate (vs original 4 gates)
    assign Y3 = ~(w | y[0] | y[3]);

endmodule