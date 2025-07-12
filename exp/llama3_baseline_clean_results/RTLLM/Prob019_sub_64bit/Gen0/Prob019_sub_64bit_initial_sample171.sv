module sub_64bit(
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output          overflow
);

    wire    [63:0] difference;
    reg     [63:0] result_reg;
    reg              overflow_reg;

    // Perform binary subtraction
    assign difference = A - B;

    // Assign result
    always @(A or B) begin
        result_reg = difference;
    end

    // Check for overflow conditions
    always @(A or B or result_reg) begin
        if ((A[63] == 0 && B[63] == 1 && result_reg[63] == 1) ||  // Positive overflow
            (A[63] == 1 && B[63] == 0 && result_reg[63] == 0))   // Negative overflow
            overflow_reg = 1'b1;
        else
            overflow_reg = 1'b0;
    end

    assign result = result_reg;
    assign overflow = overflow_reg;

endmodule