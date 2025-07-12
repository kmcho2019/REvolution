module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Directly assign Y1 based on the transition from state A (y[0]) to B when w is 1
    assign Y1 = w & y[0];

    // Directly assign Y3 based on transitions to state D (y[3]) when w is 0
    // This involves states B, C, E, and F
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule