module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic for Y1 (next state B)
    assign Y1 = y[0] & ~w;

    // Next state logic for Y3 (next state D)
    assign Y3 = (y[1] | y[2] | y[3] | y[4] | y[5]) & w;

endmodule