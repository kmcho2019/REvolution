module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Next state input for y[1] (state B): transition from A to B on w=1
    assign Y1 = y[0] & w;

    // Next state input for y[3] (state D): transitions to D on w=0 and not from D or A
    assign Y3 = (~w) & ~(y[0] | y[3]);

endmodule