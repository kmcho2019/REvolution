module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1, // next state bit corresponding to y[1]
    output       Y3  // next state bit corresponding to y[3]
);

    // Y1 = y[1] next = A->B when w=0 => y[0]&~w
    assign Y1 = y[0] & ~w;

    // Y3 = y[3] next = transitions to D on w=1 from states B,C,E,F
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule