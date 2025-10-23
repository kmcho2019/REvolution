module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1: input to state flip-flop y[1] (state B)
    assign Y1 = y[0] & w;

    // Y3: input to state flip-flop y[3] (state D)
    assign Y3 = (y[1] | y[2] | y[3] | y[4] | y[5]) & ~w;

endmodule