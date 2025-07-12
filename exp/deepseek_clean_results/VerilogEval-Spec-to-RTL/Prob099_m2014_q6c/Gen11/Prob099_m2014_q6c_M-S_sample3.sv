module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (D)
);

    // Next state A (Y1) occurs when:
    // - In state A (y[0]) and w=1, OR
    // - In state D (y[3]) and w=1
    assign Y1 = (y[0] & w) | (y[3] & w);

    // Next state D (Y3) occurs when:
    // - In state B/C/E/F and w=1, OR
    // - In state C/F and w=0
    assign Y3 = (w & (y[1] | y[2] | y[4] | y[5])) | 
                (~w & (y[2] | y[5]));

endmodule