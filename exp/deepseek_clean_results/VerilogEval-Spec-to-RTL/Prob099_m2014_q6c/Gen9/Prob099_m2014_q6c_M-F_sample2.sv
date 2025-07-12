module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y2,     // Next state y[1] (B)
    output Y4      // Next state y[3] (D)
);

    // Y2: Next state is B (from A with w=0)
    assign Y2 = y[0] & ~w;

    // Y4: Next state is D (from B with w=1 or C with w=1 or E with w=1 or F with w=1)
    assign Y4 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule