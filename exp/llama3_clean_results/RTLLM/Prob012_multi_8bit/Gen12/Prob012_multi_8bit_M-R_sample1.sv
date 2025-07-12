// Module: multi_8bit
// Description: 8-bit multiplier using shift-and-add method
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal register to hold the product
    integer i;        // Loop variable

    always @(*) begin
        prod = 0;  // Initialize product to 0
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin
                // Add A shifted left by i bits to the product
                prod = prod + (A << i);
            end
        end
        product = prod;  // Assign the final product to the output
    end

endmodule