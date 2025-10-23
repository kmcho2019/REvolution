module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 implementation: Set when transitioning from A to B (w=1)
    assign Y1 = y[0] & w;

    // Y3 implementation: Set when transitioning to D from:
    // B (y[1]) with w=0 OR
    // C (y[2]) with w=0 OR
    // E (y[4]) with w=0 OR
    // F (y[5]) with w=0
    // Using the one-hot property to simplify OR conditions
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule