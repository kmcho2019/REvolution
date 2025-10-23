module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (C)
);

    assign Y1 = w & (y[0] | y[3]);
    assign Y3 = ~w & (y[1] | y[5]);

endmodule