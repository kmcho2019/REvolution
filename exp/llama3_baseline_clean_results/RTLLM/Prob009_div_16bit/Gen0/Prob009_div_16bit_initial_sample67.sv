module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd // 16-bit remainder
);

reg [15:0] a_reg; // register to hold the dividend value
reg [7:0] b_reg;  // register to hold the divisor value

// First always block: update a_reg and b_reg with the input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: perform the division operation
always @(*) begin
    reg [15:0] temp_quotient; // temporary quotient
    reg [15:0] temp_remainder; // temporary remainder
    reg [15:0] temp_dividend; // temporary dividend
    reg [7:0] temp_divisor;   // temporary divisor

    temp_quotient = 0; // initialize the quotient to 0
    temp_dividend = a_reg; // initialize the dividend
    temp_divisor = b_reg;  // initialize the divisor

    // Perform the division operation
    for (int i = 15; i >= 0; i = i - 8) begin
        // Extract the higher bits of the dividend, matching the bit width of the divisor
        temp_remainder = temp_dividend >> (i - 7);

        // Compare the extracted dividend bits with the divisor
        if (temp_remainder >= temp_divisor) begin
            // If the dividend bits are greater, set the quotient to 1
            temp_quotient = temp_quotient | (1 << (i / 8 - 1));
            // Use the difference as the remainder
            temp_remainder = temp_remainder - temp_divisor;
        end else begin
            // If the dividend bits are not greater, set the quotient to 0
            temp_quotient = temp_quotient;
        end

        // Concatenate the remainder with the highest remaining 1-bit of the dividend
        temp_dividend = (temp_remainder << (i - 7)) | (temp_dividend & ((1 << (i - 7)) - 1));
    end

    result = temp_quotient; // assign the quotient to the output
    odd = temp_remainder;   // assign the remainder to the output
end

endmodule