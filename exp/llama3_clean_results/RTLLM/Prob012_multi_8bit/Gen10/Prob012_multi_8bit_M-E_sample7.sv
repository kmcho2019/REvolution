module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary register to hold intermediate results
    reg [7:0] shifted_A;  // Register to hold shifted multiplicand
    integer i;  // Loop counter

    always @(A or B) begin
        temp_product = 0;  // Initialize product to zero
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin
                shifted_A = A << i;  // Shift multiplicand left by i bits
                temp_product = temp_product + {8'b0, shifted_A};  // Add shifted multiplicand to product
            end
        end
        product = temp_product;  // Assign final result to output port
    end

endmodule