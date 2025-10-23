// Module: multi_8bit
// Description: 8-bit multiplier using shift-and-add method
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize the product to 0
    reg [15:0] prod;
    always @(*) begin
        prod = 16'd0;  // Reset product
        // Iterate through each bit of the multiplier (B)
        for (int i = 0; i < 8; i++) begin
            // If the current bit of B is set, add A shifted by i positions to the product
            if (B[i]) begin
                prod = prod + (A << i);
            end
        end
        // Assign the final product to the output
        product = prod;
    end

endmodule