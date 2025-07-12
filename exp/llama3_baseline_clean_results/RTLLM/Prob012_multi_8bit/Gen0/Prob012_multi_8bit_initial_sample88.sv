module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] temp_product;  // Temporary variable to hold the product
reg [7:0] temp_A;  // Temporary variable to hold the multiplicand
integer i;  // Loop counter

always @(A or B) begin
    temp_product = 0;  // Initialize the product to 0
    temp_A = A;  // Initialize the multiplicand
    for (i = 0; i < 8; i = i + 1) begin
        if (B[i] == 1) begin
            temp_product = temp_product + (temp_A << i);  // Add the multiplicand to the product at the corresponding shifted position
        end
        // No need to explicitly shift temp_A here, it will be done in the next iteration
    end
    product = temp_product;  // Assign the final product to the output port
end

endmodule