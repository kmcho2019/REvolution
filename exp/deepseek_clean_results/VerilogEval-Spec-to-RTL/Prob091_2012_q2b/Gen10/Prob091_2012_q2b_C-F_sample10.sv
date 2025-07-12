module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Transition from A (y[0]) to B when w=1
    assign Y1 = y[0] & w;

    // Y3: Transition to D (y[3]) from B/C/F when w=0 and not in A/D
    // Optimized NOR implementation for minimal gate count
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule