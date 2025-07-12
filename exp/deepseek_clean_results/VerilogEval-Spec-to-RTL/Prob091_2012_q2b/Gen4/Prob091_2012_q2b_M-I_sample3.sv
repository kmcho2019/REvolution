module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Shared inverted w signal
    wire w_n;
    assign w_n = ~w;

    // Y1 remains optimal as is
    assign Y1 = y[0] & w;

    // Optimized Y3 with balanced OR tree and shared w_n
    wire or_stage1, or_stage2;
    assign or_stage1 = y[1] | y[2];
    assign or_stage2 = y[4] | y[5];
    assign Y3 = (or_stage1 | or_stage2) & w_n;

endmodule