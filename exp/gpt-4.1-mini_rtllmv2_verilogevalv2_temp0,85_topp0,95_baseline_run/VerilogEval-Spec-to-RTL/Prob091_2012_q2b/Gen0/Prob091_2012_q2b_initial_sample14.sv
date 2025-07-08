module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 is input to y[1] flip-flop (state B)
    // B is entered from A on w=1
    assign Y1 = y[0] & w;

    // Y3 is input to y[3] flip-flop (state D)
    // D is entered from B, C, E, F on w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & (~w);

endmodule