module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] product;  // Initialize product as a 16-bit reg
    reg [7:0] temp_A;    // Temporary variable to hold the shifted multiplicand

    always @(*) begin
        product = 16'd0;  // Reset product to zero
        temp_A = A;       // Initialize temp_A with the multiplicand

        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin  // Check if the current bit of the multiplier is set
                product = product + (temp_A << i);  // Add the shifted multiplicand to the product
            end
            // No need to shift temp_A explicitly as it will be updated in the next iteration
        end
    end

endmodule