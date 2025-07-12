module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B)
    // Only transitions from state A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3 is the next state for y[3] (state D)
    // Explicitly list all transitions that lead to D:
    // From B when w=0, From C when w=0, From E when w=0, From F when w=0
    assign Y3 = ~w & (
        y[1] |  // From B
        y[2] |  // From C
        y[4] |  // From E
        y[5]   // From F
    );

endmodule