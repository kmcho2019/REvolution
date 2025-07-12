module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Active only when in state A (y[0]) and w=1
    // Optimal 2-input AND implementation
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Active when not in A/D and w=0, or in F and w=1
    // Implemented as single 3-input NOR gate for minimal area/power
    assign Y3 = ~(w | y[0] | y[3]);

endmodule