module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y2,     // Next state y[1] (B)
    output Y3,     // Next state y[2] (C)
    output Y4      // Next state y[3] (D)
);

    // Y1: Next state is A (from A with w=1 or D with w=1)
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Y2: Next state is B (from A with w=0)
    assign Y2 = y[0] & ~w;

    // Y3: Next state is C (from B with w=0 or F with w=0)
    assign Y3 = (y[1] & ~w) | (y[5] & ~w);

    // Y4: Next state is D (from B/C/E/F with w=1 or C/F with w=0)
    assign Y4 = (y[1] & w) |  // From B with w=1
                (y[2] & w) |  // From C with w=1
                (y[4] & w) |  // From E with w=1
                (y[5] & w) |  // From F with w=1
                (y[2] & ~w) | // From C with w=0
                (y[5] & ~w);  // From F with w=0

endmodule