module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    localparam [5:0] MASK_BCEF = 6'b110110; // bits for states B,C,E,F

    wire w_n = ~w;

    // Y1: next input for flip-flop y[1] (state B)
    // Transition from A(y[0]) to B on w=1
    assign Y1 = y[0] & w;

    // Y3: next input for flip-flop y[3] (state D)
    // Asserted when w=0 and current state is any of B,C,E,F (one-hot bits in MASK_BCEF)
    assign Y3 = w_n & |(y & MASK_BCEF);
endmodule