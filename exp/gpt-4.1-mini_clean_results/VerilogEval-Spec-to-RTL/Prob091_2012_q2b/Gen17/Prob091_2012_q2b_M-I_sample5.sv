module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1: input for state B (y[1]) - triggered by state A (y[0]) and w=1
    assign Y1 = y[0] & w;

    // Y3: input for state D (y[3]) - triggered by states B,C,E,F on w=0
    // Equivalent to ~w & (y[1] | y[2] | y[4] | y[5]) but optimized to
    // ~w & ~(y[0] | y[3]) due to one-hot encoding (only one bit set)
    assign Y3 = (~w) & ~(y[0] | y[3]);

endmodule