module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Y1: next state input for y[1] (state B)
    assign Y1 = y[0] & w;

    // Y3: next state input for y[3] (state D)
    // Equivalent to w == 0 and current state in {B, C, E, F}
    // Simplified to (~w) & ~(y[0] | y[3])
    assign Y3 = (~w) & ~(y[0] | y[3]);

endmodule