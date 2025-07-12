module good1 (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y2,     // Next state y[1] (B)
    output Y4      // Next state y[3] (D)
);

    // Y2: Next state is B (only from A with w=0)
    assign Y2 = y[0] & ~w;

    // Y4: Next state is D (from B/C/E/F with w=1)
    assign Y4 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule