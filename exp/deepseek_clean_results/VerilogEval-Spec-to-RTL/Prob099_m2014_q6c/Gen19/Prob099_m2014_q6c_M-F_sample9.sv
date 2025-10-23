module good1 (
    input [5:0] y,  // Current state (one-hot encoded)
    input w,        // Input signal
    output Y1,      // Next state y[1] (B)
    output Y3       // Next state y[3] (D)
);

    // Y1 (B) transitions: A->B when w=0
    assign Y1 = y[0] & ~w;

    // Y3 (D) transitions: B->D, C->D, E->D, F->D (all when w=1)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule