module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Direct assignment for Y1, using the condition from state A to B
    assign Y1 = w & y[0];

    // Direct assignment for Y3, simplifying the logic based on one-hot encoding
    // and the conditions under which state D is reached
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule