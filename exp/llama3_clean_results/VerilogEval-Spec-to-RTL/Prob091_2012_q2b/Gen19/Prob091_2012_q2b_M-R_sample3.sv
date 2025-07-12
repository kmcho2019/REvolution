module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Directly implement the next-state logic for Y1 (state B)
    assign Y1 = w & y[0];

    // Directly implement the next-state logic for Y3 (state D)
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule