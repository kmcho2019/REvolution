module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Next state input for y[1] (state B): from A with w=1
    assign Y1 = y[0] & w;

    // Next state input for y[3] (state D): from B, C, E, or F with w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule