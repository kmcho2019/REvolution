module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

    always @(*) begin
        product = 16'd0;  // Initialize product to zero
        reg [7:0] A_shifted;  // Register to hold the shifted value of A
        A_shifted = A;  // Initialize A_shifted with A
        
        // Iterate through each bit of the multiplier B
        for (int i = 0; i < 8; i++) begin
            // If the current bit of B is set, add A_shifted to the product
            if (B[i]) begin
                product = product + {8'd0, A_shifted};  // Add A_shifted to the product
            end
            
            // Shift A_shifted left by one bit for the next iteration
            A_shifted = A_shifted << 1;
        end
    end

endmodule