module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1: Next input for flip-flop y[1] (state B)
    // Only from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: Next input for flip-flop y[3] (state D)
    // From states B, C, E, F (y[1], y[2], y[4], y[5]) when w=0
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule