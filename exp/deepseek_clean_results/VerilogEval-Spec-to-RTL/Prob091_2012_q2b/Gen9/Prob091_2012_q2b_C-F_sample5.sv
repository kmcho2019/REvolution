module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for flip-flop y[1] (state B)
    // Active only when in state A (y[0]) and w=1
    assign Y1 = y[0] & w;

    // Y3: Next state for flip-flop y[3] (state D)
    // Active when not in A or D (y[0] or y[3]) and w=0
    // Using NOR implementation for optimal gate count
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule