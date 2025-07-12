module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is only set when transitioning from A to B
    assign Y1 = y[0] & w;

    // Y3 is set for transitions to D from:
    // B (y[1] & ~w), C (y[2] & ~w), E (y[4] & ~w), F (y[5] & ~w)
    // or staying in D (y[3] & ~w)
    // or from A to A (y[0] & ~w) which doesn't affect Y3
    // Simplified using bitwise operations
    wire transition_to_D;
    assign transition_to_D = (|(y[5:1] & {1'b1, 1'b1, 1'b1, 1'b1, 1'b1}) & ~w;
    
    // Y3 is the input to y[3] flip-flop, which should be set when:
    // 1. We're transitioning to D from B,C,E,F (transition_to_D)
    // 2. Or we're staying in D (y[3] & ~w)
    assign Y3 = (transition_to_D | (y[3] & ~w));

endmodule