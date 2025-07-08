module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 is input to flip-flop y[1], next state B
    assign Y1 = y[0] & w;

    // Y3 is input to flip-flop y[3], next state D
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule