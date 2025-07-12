module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal variable to hold the product
    integer i;        // Loop counter

    always @(A or B) begin
        prod = 0;  // Initialize product to zero
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin  // Check if current bit in multiplier is set
                prod = prod + (A << i);  // Add multiplicand shifted left by current bit position to product
            end
        end
        product = prod;  // Assign final product to output port
    end

endmodule