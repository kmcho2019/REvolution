module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A=000001, B=000010, etc.)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y2,     // Next state y[1] (B)
    output Y3,     // Next state y[3] (D)
    output Y4      // Next state y[4] (E)
);

    // Y1: Next state A (from A with w=1 or D with w=1)
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Y2: Next state B (only from A with w=0)
    assign Y2 = y[0] & ~w;

    // Y3: Next state D (from B,C,E,F with w=1)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

    // Y4: Next state E (from C with w=0 or E with w=0)
    assign Y4 = (y[2] | y[4]) & ~w;

endmodule