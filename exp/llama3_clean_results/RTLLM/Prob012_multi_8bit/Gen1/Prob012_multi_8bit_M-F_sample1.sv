module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

reg [7:0] temp_A;  // Temporary variable to hold the value of A
reg [7:0] temp_B;  // Temporary variable to hold the value of B

always @(*) begin
    product = 0;  // Initialize product to 0
    temp_A = A;  // Assign the value of A to temp_A
    temp_B = B;  // Assign the value of B to temp_B

    for (int i = 0; i < 8; i++) begin
        if (temp_B[0]) begin  // Check if the least significant bit of B is 1
            product = product + {8'd0, temp_A};  // Add A to the product if the bit is 1
        end
        temp_A = temp_A << 1;  // Shift A left by one bit
        temp_B = temp_B >> 1;  // Shift B right by one bit
    end
end

endmodule