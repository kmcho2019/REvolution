module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to hold the product
reg [7:0] A_reg;  // Internal register to hold the multiplicand (A)
reg [7:0] B_reg;  // Internal register to hold the multiplier (B)
integer i;  // Loop counter

always @(*) begin
    product_reg = 0;  // Initialize product to 0
    A_reg = A;  // Initialize multiplicand
    B_reg = B;  // Initialize multiplier
    
    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[0] == 1) begin
            product_reg = product_reg + (A_reg << i);  // Add A to product if current bit of B is 1
        end
        B_reg = B_reg >> 1;  // Right shift B by 1 bit
    end
    
    product = product_reg;  // Assign final product to output
end

endmodule