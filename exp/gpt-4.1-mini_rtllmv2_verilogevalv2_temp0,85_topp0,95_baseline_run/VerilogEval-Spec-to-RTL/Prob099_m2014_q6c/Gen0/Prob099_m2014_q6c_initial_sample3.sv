module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Next state signal Y1 corresponds to y[1] next state (state B)
    assign Y1 = y[0] & ~w;

    // Next state signal Y3 corresponds to y[3] next state (state D)
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule