module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] temp_product;  // Temporary variable to hold the product
reg [7:0] temp_A;  // Temporary variable to hold the multiplicand

always @(A or B) begin
    temp_product = 16'd0;  // Initialize the product to 0
    temp_A = A;  // Initialize the multiplicand

    // Iterate through each bit of the multiplier
    for (int i = 0; i < 8; i++) begin
        // If the current bit of the multiplier is set, add the multiplicand to the product
        if (B[i] == 1'b1) begin
            temp_product = temp_product + (temp_A << i);
        end

        // Shift the multiplicand left by one bit for the next iteration
        temp_A = temp_A << 1;
    end

    // Assign the final product to the output port
    product = temp_product;
end

endmodule