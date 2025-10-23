module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Transition occurs only from state A (y[0]=1) when w=1
    // This is optimal as it directly implements the A->B transition
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transitions to D occur when:
    // 1. Current state is not A (y[0]=0) and not D (y[3]=0)
    // 2. Input w=0
    // Using one-hot property: ~(y[0] | y[3]) is equivalent to checking all other states
    // This implementation minimizes gates while maintaining correctness
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule