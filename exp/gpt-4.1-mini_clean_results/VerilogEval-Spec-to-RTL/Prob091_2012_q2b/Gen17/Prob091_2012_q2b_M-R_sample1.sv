module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Next-state input for state B (y[1]): from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Next-state input for state D (y[3]): from states other than A(y[0]) and D(y[3]) when w=0
    assign Y3 = (~w) & (~y[0]) & (~y[3]);

endmodule