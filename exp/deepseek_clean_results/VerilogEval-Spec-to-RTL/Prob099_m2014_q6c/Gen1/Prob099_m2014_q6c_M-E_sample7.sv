module TopModule(
    input [5:0] y,
    input w,
    output Y2,
    output Y4
);

    // Next state logic for Y2 (next state C)
    assign Y2 = (y[1] | y[5]) & ~w;

    // Next state logic for Y4 (next state E)
    assign Y4 = (y[2] | y[4]) & ~w;

endmodule