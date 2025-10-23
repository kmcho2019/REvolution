module div_16bit(
    input   [15:0] A,  // 16-bit dividend
    input   [7:0]  B,  // 8-bit divisor
    output  [15:0] result,  // 16-bit quotient
    output  [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

// First always block: Update input registers
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: Perform division operation
always @(*) begin
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    reg [7:0]  temp_b;
    reg [15:0] temp_a;
    
    temp_a = a_reg;
    temp_b = b_reg;
    temp_result = 0;
    temp_odd = 0;
    
    for (int i = 15; i >= 8; i = i - 1) begin
        // Extract the higher bits of the dividend, matching the bit width of the divisor
        reg [7:0] temp_dividend;
        temp_dividend = temp_a >> (i - 7);
        
        // Compare these bits with the divisor
        if (temp_dividend >= temp_b) begin
            // Set the quotient bit to 1
            temp_result = temp_result + (1 << (i - 8));
            // Use the difference as the remainder
            temp_odd = (temp_dividend - temp_b) << (i - 8);
        end else begin
            // Set the quotient bit to 0
            temp_result = temp_result;
            // Use the dividend as the remainder
            temp_odd = temp_dividend << (i - 8);
        end
        
        // Concatenate the remainder with the next highest remaining bit of the dividend
        temp_a = (temp_a << 1) | (temp_odd[0] ? 1 : 0);
        temp_a = temp_a & ~(1 << i);
    end
    
    // Assign the final result and remainder
    result = temp_result;
    odd = temp_a;
end

endmodule