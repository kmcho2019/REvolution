module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Directly assign Y1 based on the transition to state B
    assign Y1 = w & y[0];

    // Directly assign Y3 based on the transitions to state D
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule