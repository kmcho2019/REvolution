module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 (input for flip-flop y[1] for state B): from A on w=1
    assign Y1 = y[0] & w;

    // Y3 (input for flip-flop y[3] for state D): from B,C,D,E,F on w=0
    assign Y3 = (y[1] | y[2] | y[3] | y[4] | y[5]) & (~w);

endmodule