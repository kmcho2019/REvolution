module TopModule (
    input [5:0] y,  // Current state in one-hot (y[0]=A, y[1]=B,..., y[5]=F)
    input w,       // Input signal
    output Y1,     // Next state y[0] (state A)
    output Y3      // Next state y[2] (state C)
);

    // Y1 (next state A) = current A with w=1 OR current D with w=1
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Y3 (next state C) = current B with w=0 OR current C with w=0 OR current F with w=0
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[5] & ~w);

endmodule