module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Directly implement Y1 (state B) based on the current state (y) and input (w)
    assign Y1 = w & y[0];

    // Directly implement Y3 (state D) based on the current state (y) and input (w)
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule