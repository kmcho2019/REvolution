module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    wire y0_or_y3 = y[0] | y[3];

    // Next state input for flip-flop y[1] (state B)
    assign Y1 = y[0] & w;

    // Next state input for flip-flop y[3] (state D)
    assign Y3 = w_n & ~y0_or_y3;
endmodule