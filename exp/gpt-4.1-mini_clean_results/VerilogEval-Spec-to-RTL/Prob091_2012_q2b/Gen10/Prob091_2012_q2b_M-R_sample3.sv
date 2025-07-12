module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 is asserted only when in state A (y[0]) and w=1 to transition to B
    assign Y1 = (y[0] & w);

    // Y3 is asserted when w=0 and current state is B, C, E, or F (y[1], y[2], y[4], y[5]) to transition to D
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule