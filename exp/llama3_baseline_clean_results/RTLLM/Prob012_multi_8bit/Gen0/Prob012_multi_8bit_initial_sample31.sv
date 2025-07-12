module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] temp_product;  // Temporary variable to hold the product
reg [7:0] temp_A;  // Temporary variable for A to perform shifting

initial begin
    temp_product = 0;
    temp_A = A;
end

always @(A or B) begin
    temp_product = 0;
    temp_A = A;
    for (int i = 0; i < 8; i++) begin
        if (B[i] == 1'b1) begin
            temp_product = temp_product + (temp_A << i);
        end
        // Shifting A for the next iteration
        temp_A = temp_A << 1;
    end
end

assign product = temp_product;

endmodule