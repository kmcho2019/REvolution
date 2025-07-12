module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Y1: next input for flip-flop y[1] = transition A->B on w=1
    assign Y1 = y[0] & w;

    // Y3: next input for flip-flop y[3] = transition to D on w=0 from states B, C, E, F
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
endmodule