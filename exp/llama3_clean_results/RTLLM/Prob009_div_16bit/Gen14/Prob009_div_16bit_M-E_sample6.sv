module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

// Look-up table to store pre-computed values of the divisor shifted by different amounts
reg [15:0] lut [8];

// Control unit signals
reg [3:0] shift_amount;
reg [15:0] temp_quotient;
reg [15:0] temp_remainder;

always @(*) begin
    // Initialize look-up table
    for (int i = 0; i < 8; i++) begin
        lut[i] = B << i;
    end

    // Initialize control unit signals
    shift_amount = 8;
    temp_quotient = 0;
    temp_remainder = A;

    // Perform division
    while (shift_amount > 0) begin
        // Compare shifted divisor with dividend using LUT
        if (lut[shift_amount - 1] <= temp_remainder) begin
            // Update quotient and remainder
            temp_quotient = temp_quotient | (1 << (shift_amount - 1));
            temp_remainder = temp_remainder - lut[shift_amount - 1];
        end

        // Shift divisor to the left
        shift_amount = shift_amount - 1;
    end

    // Update output signals
    result = temp_quotient;
    odd = temp_remainder;
end

endmodule