module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Transition: A->B when w=1
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transitions: B->D, C->D, E->D, F->D when w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule