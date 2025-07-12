module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Next state input for B (y[1]) occurs when currently in A (y[0]) and w=1
    assign Y1 = y[0] & w;

    // Next state input for D (y[3]) occurs when w=0 and current state is B, C, E, or F
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule