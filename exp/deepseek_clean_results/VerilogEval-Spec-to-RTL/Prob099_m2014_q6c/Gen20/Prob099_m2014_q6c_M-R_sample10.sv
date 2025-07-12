module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A=y[0], B=y[1],..., F=y[5])
    input w,       // Input signal
    output Y2,     // Next state y[1] (state B)
    output Y4      // Next state y[3] (state D)
);

    // Next state logic for Y2 (y[1] - state B)
    assign Y2 = y[0] & ~w;  // A->B when w=0

    // Next state logic for Y4 (y[3] - state D)
    assign Y4 = (y[1] & w) |   // B->D when w=1
                (y[2] & w) |   // C->D when w=1
                (y[4] & w) |   // E->D when w=1
                (y[5] & w);    // F->D when w=1

endmodule