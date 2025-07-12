module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1, // next state's y[1] bit (state B)
    output       Y3  // next state's y[3] bit (state D)
);

    // Y1 is set when next state is B: from A with w=0
    assign Y1 = y[0] & ~w;

    // Y3 is set when next state is D: from B,C,E,F with w=1
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule