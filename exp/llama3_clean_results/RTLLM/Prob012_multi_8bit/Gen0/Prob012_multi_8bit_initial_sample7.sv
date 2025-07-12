module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to hold the product
reg [7:0] A_reg;  // Internal register to hold the multiplicand for shifting
integer i;  // Loop counter

always @(A or B) begin
    product_reg = 0;  // Initialize product register to 0
    A_reg = A;  // Load multiplicand into internal register

    for (i = 0; i < 8; i = i + 1) begin
        if (B[i]) begin  // Check if the current bit of the multiplier is 1
            product_reg = product_reg + (A_reg << i);  // Add the shifted multiplicand to the product
        end
        // No need to explicitly shift A_reg here as we are using A_reg << i in the addition
    end

    product = product_reg;  // Assign the final product to the output port
end

endmodule