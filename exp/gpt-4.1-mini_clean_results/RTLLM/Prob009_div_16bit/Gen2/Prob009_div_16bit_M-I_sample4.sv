module div_16bit(
    input  [15:0] A,      // 16-bit dividend
    input  [7:0]  B,      // 8-bit divisor
    output reg [15:0] result,  // Quotient
    output reg [15:0] odd      // Remainder
);

// Internal registers to hold inputs
reg [15:0] a_reg;
reg [7:0]  b_reg;

integer i;
reg [7:0] upper_bits;    // upper bits for comparison (width of divisor)
reg [7:0] sub_result;    // subtraction result for remainder update
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    // Register inputs combinationally
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    quotient  = 16'b0;
    remainder = 16'b0;

    // Iterate from MSB to LSB of dividend
    for (i = 15; i >= 0; i = i - 1) begin
        // Concatenate remainder shifted left by 1 with current dividend bit
        // This forms 17 bits but we only need upper 8 bits for comparison
        // remainder is 16 bits, but only upper 8 bits for comparison with divisor
        // So extract bits [15:8] after shift and add dividend bit
        // Approach: shift remainder left by 1, add dividend bit as LSB, then take upper 8 bits

        remainder = remainder << 1;       // Shift left remainder by 1
        remainder[0] = a_reg[i];          // Bring in current dividend bit at LSB of remainder

        upper_bits = remainder[15:8];    // Extract upper 8 bits to compare with divisor b_reg

        if (upper_bits >= b_reg) begin
            sub_result = upper_bits - b_reg;
            // Update remainder upper bits with subtraction result
            remainder[15:8] = sub_result;
            quotient[i] = 1'b1;
        end else begin
            quotient[i] = 1'b0;
            // remainder upper bits stay unchanged
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule