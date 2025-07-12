module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next y[0] (state A)
    output Y3      // Next y[2] (state C)
);

    // State assignments (one-hot)
    // A = y[0], B = y[1], C = y[2], D = y[3], E = y[4], F = y[5]

    // Y1 is next y[0] (state A) - occurs from A with w=1 or D with w=1
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Y3 is next y[2] (state C) - occurs from B with w=0 or F with w=0
    assign Y3 = (y[1] & ~w) | (y[5] & ~w);

endmodule