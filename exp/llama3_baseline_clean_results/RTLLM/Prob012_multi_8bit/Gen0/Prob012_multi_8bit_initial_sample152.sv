module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] temp_product;  // Temporary variable to store the product

always @(A or B) begin
    temp_product = 0;  // Initialize the temporary product to 0
    reg [7:0] temp_A;  // Temporary variable to store the shifted multiplicand
    temp_A = A;  // Initialize the temporary multiplicand to A

    for (int i = 0; i < 8; i++) begin
        if (B[i] == 1'b1) begin
            temp_product = temp_product + (temp_A << i);  // Add the shifted multiplicand to the product if the current bit of B is 1
        end
        // No need to explicitly shift temp_A here, as it will be done in the next iteration
    end

    product = temp_product;  // Assign the final product to the output port
end

endmodule