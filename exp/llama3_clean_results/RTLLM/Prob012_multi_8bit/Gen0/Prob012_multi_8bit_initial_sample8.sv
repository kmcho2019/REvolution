module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

    integer i;

    always @(*) begin
        product = 0;  // Initialize product to 0 for each new calculation
        for (i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin  // Check each bit of the multiplier
                product = product + (A << i);  // Add shifted multiplicand to product if bit is set
            end
        end
    end

endmodule