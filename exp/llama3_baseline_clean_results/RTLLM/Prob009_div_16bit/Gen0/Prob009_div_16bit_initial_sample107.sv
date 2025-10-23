module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;  // register to hold the dividend
reg [7:0] b_reg;   // register to hold the divisor
reg [15:0] result_reg;  // register to hold the quotient
reg [15:0] odd_reg;     // register to hold the remainder

// First always block: Update input registers
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: Perform division operation
always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    
    for (int i = 15; i >= 8; i--) begin
        // Extract higher bits of dividend, matching the bit width of the divisor
        reg [7:0] dividend_bits;
        dividend_bits = odd_reg >> (i - 7);
        
        // Compare the dividend bits with the divisor
        if (dividend_bits >= b_reg) begin
            // Set the quotient to 1
            result_reg = result_reg | (1 << (i - 8));
            // Update the remainder
            odd_reg = (odd_reg & ((1 << (i - 7)) - 1)) | ((dividend_bits - b_reg) << (i - 7));
        end else begin
            // Set the quotient to 0
            result_reg = result_reg;
            // Update the remainder
            odd_reg = (odd_reg & ((1 << (i - 7)) - 1)) | (dividend_bits << (i - 7));
        end
    end
    
    // Assign the final quotient and remainder to the output ports
    result = result_reg;
    odd = odd_reg;
end

endmodule