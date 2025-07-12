module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary register to store the product
    reg [7:0] temp_A;  // Temporary register to store the multiplicand
    integer i;  // Loop counter

    always @(*) begin
        temp_product = 0;  // Initialize the product to zero
        temp_A = A;  // Initialize the multiplicand
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1) begin  // Check if the current bit of the multiplier is set
                temp_product = temp_product + (temp_A << i);  // Add the shifted multiplicand to the product
            end
            // No need to shift A here as we are using the << operator to shift A
        end
        product = temp_product;  // Assign the final product to the output
    end

endmodule