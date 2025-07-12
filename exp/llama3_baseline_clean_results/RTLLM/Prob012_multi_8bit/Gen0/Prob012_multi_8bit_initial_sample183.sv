module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

always @(A or B) begin
    product = 16'd0;  // Initialize product to zero
    reg [7:0] temp_A;  // Temporary variable to hold A
    temp_A = A;  // Assign A to temp_A
    for (int i = 0; i < 8; i++) begin
        if (B[i] == 1'b1) begin
            product = product + (temp_A << i);  // If the current bit of B is 1, add shifted A to product
        end
        temp_A = temp_A << 1;  // Shift A left by one bit for the next iteration
    end
end

endmodule