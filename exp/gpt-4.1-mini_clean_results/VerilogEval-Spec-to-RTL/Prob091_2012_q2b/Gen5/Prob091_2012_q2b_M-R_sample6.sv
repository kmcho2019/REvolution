module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 is the next input for flip-flop y[1]: from A(y[0]) on w=1
    assign Y1 = y[0] & w;

    // Y3 is the next input for flip-flop y[3]: from B(y[1]), C(y[2]), E(y[4]), F(y[5]) on w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & (~w);

endmodule