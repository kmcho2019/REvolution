module TopModule (
    input  [5:0] y,  // One-hot encoded state
    input        w,  // Input signal
    output       Y1, // Next input for state B flip-flop (y[1])
    output       Y3  // Next input for state D flip-flop (y[3])
);

    // Y1 = A & w = y[0] & w
    assign Y1 = y[0] & w;

    // Y3 = (B | C | E | F) & ~w = (y[1] | y[2] | y[4] | y[5]) & ~w
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & (~w);

endmodule