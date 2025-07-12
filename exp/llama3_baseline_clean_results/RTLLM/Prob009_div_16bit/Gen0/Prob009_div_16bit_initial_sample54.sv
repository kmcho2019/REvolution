module div_16bit (
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg; // Register to hold the dividend
reg [7:0] b_reg;  // Register to hold the divisor

// Always block to update registers with input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Always block to perform the division operation
always @(*) begin
    reg [15:0] temp_quotient; // Temporary quotient
    reg [15:0] temp_remainder; // Temporary remainder
    reg [7:0] divisor; // Divisor
    reg [7:0] dividend_bits; // Higher bits of the dividend
    reg [7:0] subtracted; // Difference between dividend bits and divisor
    integer i; // Loop counter

    // Initialize the quotient and remainder
    temp_quotient = 16'd0;
    temp_remainder = a_reg;

    // Perform the division
    for (i = 15; i >= 7; i = i - 8) begin
        // Extract the higher bits of the dividend
        dividend_bits = temp_remainder[15:8];

        // Compare the dividend bits with the divisor
        if (dividend_bits > b_reg) begin
            // Set the quotient to 1
            temp_quotient = temp_quotient << 1 | 1'b1;
            // Update the remainder
            subtracted = dividend_bits - b_reg;
            temp_remainder = {subtracted, temp_remainder[7:0]};
        end else begin
            // Set the quotient to 0
            temp_quotient = temp_quotient << 1 | 1'b0;
            // Update the remainder
            temp_remainder = {dividend_bits, temp_remainder[7:0]};
        end
    end

    // Update the result and odd signals
    result = temp_quotient;
    odd = temp_remainder;
end

endmodule