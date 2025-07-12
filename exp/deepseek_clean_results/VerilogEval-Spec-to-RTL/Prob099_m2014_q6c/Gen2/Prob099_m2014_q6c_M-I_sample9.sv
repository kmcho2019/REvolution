module TopModule(
    input [5:0] y,    // Current state (one-hot encoded)
    input w,          // Input
    output Y1, Y3     // Next state bits y[1] (B) and y[3] (D)
);

    // Y1 (next y[1] = B): Only transition is A->B when w=0
    assign Y1 = y[0] & ~w;

    // Y3 (next y[3] = D): All transitions to D (B/C/E/F->D when w=1, except F->D when w=1)
    // Optimized by factoring w term
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule