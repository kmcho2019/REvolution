module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal register to store the product
    reg [7:0] temp_A;  // Temporary register to store the multiplicand

    always @(*) begin
        prod = 16'd0;  // Initialize product to zero
        temp_A = A;  // Initialize temporary multiplicand

        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin  // Check if current bit is set
                prod = prod + (temp_A << i);  // Add shifted multiplicand to product
            end
            // No need to shift multiplicand here, it's already considered in the next iteration
        end

        product = prod;  // Assign final product to output port
    end

endmodule