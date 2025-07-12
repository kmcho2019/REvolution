module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

always @(A or B) begin
    product = 16'd0;  // Initialize product to zero
    reg [7:0] temp_A = A;  // Temporary register for A
    for (int i = 0; i < 8; i++) begin
        if (B[i] == 1'b1) begin
            product = product + (temp_A << i);  // Add shifted A to product if B's bit is set
        end
        // No need to explicitly shift temp_A here, as it's taken care of in the addition operation
    end
end

endmodule