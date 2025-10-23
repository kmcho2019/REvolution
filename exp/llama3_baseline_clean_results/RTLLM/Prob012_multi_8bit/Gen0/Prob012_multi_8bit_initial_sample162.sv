module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to hold the product
integer i;  // Loop counter

always @(*) begin
    product_reg = 0;  // Initialize product to 0
    for (i = 0; i < 8; i = i + 1) begin
        if (B[i] == 1'b1) begin  // Check if the current bit of B is set
            product_reg = product_reg + (A << i);  // Add A shifted by i positions to the product
        end
    end
    product = product_reg;  // Assign the final product to the output
end

endmodule