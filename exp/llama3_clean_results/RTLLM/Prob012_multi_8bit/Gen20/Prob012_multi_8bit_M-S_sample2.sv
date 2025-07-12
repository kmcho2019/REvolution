// Module: multi_8bit
// Description: 8-bit multiplier using shift-and-add method
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize product to zero
    reg [15:0] prod;
    always @(A or B) begin
        prod = 0;
        for (int i = 0; i < 8; i++) begin
            // Shift A left by i positions and add to product if B's i-th bit is set
            if (B[i]) begin
                prod = prod + (A << i);
            end
        end
    end

    // Assign calculated product to output
    assign product = prod;

endmodule