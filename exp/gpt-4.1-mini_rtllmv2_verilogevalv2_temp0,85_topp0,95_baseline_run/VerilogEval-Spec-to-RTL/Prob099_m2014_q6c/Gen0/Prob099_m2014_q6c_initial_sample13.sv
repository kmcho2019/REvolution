module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 (next y[1]) is high when next state is B
    // From A(0) and w=0 → B(1)
    assign Y1 = y[0] & ~w;

    // Y3 (next y[3]) is high when next state is D
    // From B, C, E, F when w=1 → D(3)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule