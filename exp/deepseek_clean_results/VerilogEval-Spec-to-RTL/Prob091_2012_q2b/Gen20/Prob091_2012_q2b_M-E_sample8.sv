module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is active when transitioning to state B (y[1])
    // Only possible from state A (y[0]) with w=1
    assign Y1 = y[0] & w;

    // Y3 is active when transitioning to state D (y[3])
    // Possible from:
    // - state B (y[1]) with w=0
    // - state C (y[2]) with w=0
    // - state E (y[4]) with w=0
    // - state F (y[5]) with w=0
    // Simplified using one-hot property: if not in A and w=0
    assign Y3 = ~w & (|y[5:1]);

endmodule