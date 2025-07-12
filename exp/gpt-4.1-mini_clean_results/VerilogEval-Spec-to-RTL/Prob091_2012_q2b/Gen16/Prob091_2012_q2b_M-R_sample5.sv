module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Complement of input w for readability
    wire w_n = ~w;

    // Next-state input for flip-flop y[1] (state B)
    assign Y1 = y[0] & w;

    // Next-state input for flip-flop y[3] (state D)
    // Active when w is 0 and current state is not A or D
    assign Y3 = w_n & ~(y[0] | y[3]);

endmodule