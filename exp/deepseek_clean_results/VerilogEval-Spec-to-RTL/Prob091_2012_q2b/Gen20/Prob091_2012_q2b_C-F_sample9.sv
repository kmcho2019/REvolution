module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for B (y[1]) - active only when in A (y[0]) and w=1
    assign Y1 = y[0] & w;

    // Y3: Next state for D (y[3]) - active when not in A/D and w=0
    // Using NOR gate for power optimization
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule