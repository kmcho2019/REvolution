module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Y1: next input for state B flip-flop
    assign Y1 = y[0] & w;

    // Y3: next input for state D flip-flop
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule