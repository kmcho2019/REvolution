module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1, // next-state bit corresponding to y[1] (B)
    output       Y3  // next-state bit corresponding to y[3] (D)
);

    // Next-state bit y[1] (state B) is set only if current state is A(y[0]) and w=0
    assign Y1 = y[0] & ~w;

    // Next-state bit y[3] (state D) is set if w=1 and current state is any except A
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule