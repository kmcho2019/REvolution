module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state y[0] (state A)
    output Y3      // Next state y[2] (state C)
);

    // Next state logic for Y1 (y[0] - state A)
    assign Y1 = y[3] & w;  // D->A when w=1

    // Next state logic for Y3 (y[2] - state C)
    assign Y3 = (y[1] & ~w) |  // B->C when w=0
                (y[5] & ~w);   // F->C when w=0

endmodule