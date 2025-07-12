module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (C)
);

    // Y1: Next state is A (from A with w=1 or D with w=1)
    assign Y1 = (y[0] & w) |  // From A with w=1
                (y[3] & w);  // From D with w=1

    // Y3: Next state is C (from B with w=0 or F with w=0)
    assign Y3 = (y[1] & ~w) |  // From B with w=0
                (y[5] & ~w);   // From F with w=0

endmodule