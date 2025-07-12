module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Next state input for y[1] (B) is active when current state is A (y[0]) and w=1
    assign Y1 = y[0] & w;

    // Next state input for y[3] (D) is active when w=0 and current state is B, C, E, or F
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule