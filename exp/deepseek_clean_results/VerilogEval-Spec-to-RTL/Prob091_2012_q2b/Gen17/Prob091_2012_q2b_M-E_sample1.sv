module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 logic: Next state for y[1] (state B)
    // Active when in state A (y[0]) and w=1
    assign Y1 = y[0] & w;

    // Y3 logic: Next state for y[3] (state D)
    // Active when:
    // 1. In state B (y[1]) and w=0, OR
    // 2. In state C (y[2]) and w=0, OR
    // 3. In state F (y[5]) and w=0
    wire transition_to_D;
    assign transition_to_D = (y[1] | y[2] | y[5]) & ~w;
    assign Y3 = transition_to_D;

endmodule