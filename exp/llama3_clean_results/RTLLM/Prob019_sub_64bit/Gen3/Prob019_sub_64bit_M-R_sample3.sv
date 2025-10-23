module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    reg [63:0] result_reg;
    reg overflow_reg;

    always @(*) begin
        // Perform binary subtraction of A and B
        result_reg = A - B;

        // Check for overflow conditions by examining the sign bits of A, B, and the result
        overflow_reg = (A[63] == 1'b0 && B[63] == 1'b1 && result_reg[63] == 1'b1) || 
                       (A[63] == 1'b1 && B[63] == 1'b0 && result_reg[63] == 1'b0);
    end

    // Continuous assignment to output ports
    assign result = result_reg;
    assign overflow = overflow_reg;

endmodule