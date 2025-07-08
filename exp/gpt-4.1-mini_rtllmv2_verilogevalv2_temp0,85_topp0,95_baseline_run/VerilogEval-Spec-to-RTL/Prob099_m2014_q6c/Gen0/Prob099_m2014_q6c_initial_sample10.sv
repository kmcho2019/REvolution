module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // y[0]: A
    // y[1]: B
    // y[2]: C
    // y[3]: D
    // y[4]: E
    // y[5]: F

    // Next state Y1 (next y[1]) logic:
    // Y1 = y[0] & ~w
    assign Y1 = y[0] & ~w;

    // Next state Y3 (next y[3]) logic:
    // Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule