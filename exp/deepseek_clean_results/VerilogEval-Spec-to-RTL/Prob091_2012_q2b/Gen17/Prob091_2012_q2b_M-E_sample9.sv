module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is set only when in state A (y[0]) and w=1 (transition to B)
    assign Y1 = y[0] & w;

    // Y3 is set when:
    // 1. In state B (y[1]) and w=0 (transition to D)
    // 2. In state C (y[2]) and w=0 (transition to D)
    // 3. In state F (y[5]) and w=0 (transition to D)
    assign Y3 = (y[1] | y[2] | y[5]) & ~w;

endmodule