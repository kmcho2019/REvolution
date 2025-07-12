module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to store the product
reg [7:0] A_reg;        // Internal register to store the multiplicand
reg [7:0] B_reg;        // Internal register to store the multiplier
integer i;              // Loop counter

always @(A or B) begin
    product_reg = 0;    // Initialize the product register
    A_reg = A;         // Load the multiplicand into the internal register
    B_reg = B;         // Load the multiplier into the internal register

    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[0]) begin  // Check if the least significant bit of the multiplier is 1
            product_reg = product_reg + {{8{i}}{A_reg}};  // Add the multiplicand to the product at the corresponding shifted position
        end
        A_reg = {A_reg[6:0], 1'b0};  // Shift the multiplicand left by one bit (with zero fill)
        B_reg = B_reg >> 1;        // Shift the multiplier right by one bit
    end

    product = product_reg;  // Assign the final product to the output port
end

endmodule