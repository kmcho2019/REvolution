module div_16bit(
    input  [15:0] A,  // 16-bit dividend
    input  [7:0]  B,  // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

// First always block: Register the input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: Perform the division operation
always @(*) begin
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0]  temp;

    quotient = 16'b0;  // Initialize quotient to 0
    remainder = a_reg[15:8];  // Initialize remainder with the higher 8 bits of the dividend

    // Perform the division for 8 iterations (since the divisor is 8 bits)
    for (int i = 7; i >= 0; i--) begin
        // Compare the current remainder with the divisor
        if (remainder >= {8'b0, b_reg}) begin
            // If remainder is greater, subtract the divisor and set the current bit of the quotient
            temp = remainder - {8'b0, b_reg};
            quotient[7 - i] = 1'b1;
        end else begin
            // If remainder is not greater, do not subtract and keep the current bit of the quotient as 0
            temp = remainder;
        end

        // Concatenate the next bit of the dividend with the current remainder
        remainder = {temp[7:1], a_reg[7 - i]};
    end

    // Assign the final quotient and remainder
    result = {8'b0, quotient};  // Sign-extend the quotient to 16 bits
    odd    = {8'b0, remainder[7:0]};  // Sign-extend the remainder to 16 bits
end

endmodule