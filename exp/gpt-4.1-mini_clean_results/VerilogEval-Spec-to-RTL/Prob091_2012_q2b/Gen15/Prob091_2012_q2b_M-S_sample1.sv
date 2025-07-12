module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Y1 is the next input to y[1] (state B): active when in state A (y[0]) and w=1
    assign Y1 = y[0] & w;

    // Y3 is the next input to y[3] (state D): active when w=0 and not in states A or D
    assign Y3 = (~w) & (~y[0]) & (~y[3]);

endmodule