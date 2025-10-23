module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B)
    // Only transitions from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3 is the next state for y[3] (state D)
    // Transitions from B, C, E, or F when w=0
    // Using factored ~w and OR of one-hot states (mutually exclusive)
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule