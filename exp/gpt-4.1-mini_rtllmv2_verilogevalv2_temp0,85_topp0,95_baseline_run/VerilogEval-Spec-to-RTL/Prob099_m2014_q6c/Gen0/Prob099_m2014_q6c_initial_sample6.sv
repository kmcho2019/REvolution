module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 corresponds to next state y[1] (state B)
    // From A->B on input 0: y[0] & ~w
    assign Y1 = y[0] & (~w);

    // Y3 corresponds to next state y[3] (state D)
    // From B,C,E,F to D on input 1
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule