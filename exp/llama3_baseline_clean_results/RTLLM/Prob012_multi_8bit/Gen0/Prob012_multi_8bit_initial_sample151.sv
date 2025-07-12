module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register for the product
reg [7:0] A_reg;  // Internal register for the multiplicand
reg [7:0] B_reg;  // Internal register for the multiplier
integer i;  // Loop counter

initial begin
    product_reg = 16'd0;  // Initialize product to zero
    A_reg = A;  // Initialize multiplicand
    B_reg = B;  // Initialize multiplier
end

always @(*) begin
    product_reg = 16'd0;  // Reset product at the start of each calculation
    A_reg = A;  // Update multiplicand
    B_reg = B;  // Update multiplier
    
    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[7 - i] == 1'b1) begin
            product_reg = product_reg + (A_reg << i);  // Add shifted multiplicand to product if current bit in multiplier is 1
        end
    end
    
    product = product_reg;  // Assign final product to output
end

endmodule