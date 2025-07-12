module TopModule (
    input [5:0] y,  // One-hot encoded current state (A=y[0], B=y[1],..., F=y[5])
    input w,        // Input signal
    output Y1,      // Next state B (y[1])
    output Y3       // Next state D (y[3])
);

    // Next state B (Y1) occurs only when in state A and w=0
    assign Y1 = y[0] & ~w;

    // Next state D (Y3) occurs when:
    // - In state B and w=1, or
    // - In state C and w=1, or
    // - In state E and w=1, or
    // - In state F and w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule