module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 is next input for flip-flop y[1] (state B)
    // Y1 = A & w = y[0] & w
    assign Y1 = y[0] & w;

    // Y3 is next input for flip-flop y[3] (state D)
    // Y3 = (B & ~w) | (C & ~w) | (E & ~w) | (F & ~w)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule