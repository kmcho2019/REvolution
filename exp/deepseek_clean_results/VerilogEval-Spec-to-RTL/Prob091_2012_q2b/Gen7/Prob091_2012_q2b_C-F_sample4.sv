module TopModule (
    input [5:0] y,    // Current state in one-hot encoding: y[5:0] = A,B,C,D,E,F
    input w,          // Input signal
    output Y1,        // Next state for y[1] (state B)
    output Y3         // Next state for y[3] (state D)
);

    // State transition logic:
    // Y1: Transition to state B occurs only from state A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: Transition to state D occurs when:
    // 1. Not in states A or D (using one-hot property: ~(y[0] | y[3]))
    // 2. Input w is 0
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule