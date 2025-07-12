module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp;  // Temporary variable to store the product

    always @(A or B) begin
        temp = 0;  // Initialize the product to 0
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                // If the current bit of the multiplier is 1, add the multiplicand shifted by the current bit position to the product
                temp = temp + (A << i);
            end
        end
        product = temp;  // Assign the final product to the output port
    end

endmodule