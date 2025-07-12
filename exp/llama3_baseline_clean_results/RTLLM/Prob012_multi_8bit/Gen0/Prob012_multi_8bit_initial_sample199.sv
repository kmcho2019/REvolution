module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to store the product
reg [7:0] A_reg;  // Internal register to store A
reg [7:0] B_reg;  // Internal register to store B
integer i;  // Loop counter

always @(A or B) begin
    product_reg = 0;  // Initialize product to 0
    A_reg = A;  // Store A in internal register
    B_reg = B;  // Store B in internal register
    
    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[0] == 1'b1) begin
            product_reg = product_reg + {{8{i{1'b0}}, A_reg};  // Add shifted A to product if LSB of B is 1
        end
        A_reg = {1'b0, A_reg[7:1]};  // Shift A left by one bit
        B_reg = B_reg >> 1;  // Shift B right by one bit (to check the next bit in the next iteration)
    end
    
    product = product_reg;  // Assign final product to output
end

endmodule