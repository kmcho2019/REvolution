module div_16bit(
    input  [15:0] A,      // 16-bit dividend
    input  [7:0]  B,      // 8-bit divisor
    output reg [15:0] result,  // Quotient
    output reg [15:0] odd      // Remainder
);

    integer i;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [23:0] current;  // Wider to hold remainder concat with next bits

    always @(*) begin
        quotient = 16'b0;
        remainder = 16'b0;
        current = 0;

        // Initialize current with 0 remainder and highest bits of A
        // The remainder width is 16 bits, but we follow the process:
        // At each step, extract upper bits matching divisor width from 'current'
        // Then compare and update

        // Process bits from MSB to LSB of dividend A
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit and bring in next dividend bit
            current = {remainder, A[i]};

            // Extract upper bits matching divisor width (8 bits from MSB side)
            // From current (width = 16 + 1 = 17 bits actually, remainder is 16)
            // Since remainder is 16 bits, current is 17 bits
            // But here we have current wider (24 bits) for generality

            // upper_bits: bits [23:16] if we concatenate remainder(16 bits) and A[i] (1 bit), 
            // but actually current = {remainder, A[i]} is 17 bits only,
            // so extract bits [16:9] to get 8 bits, this matches upper 8 bits of remainder concat with A[i]
            // To fix: remainder is 16 bits, A[i] 1 bit => 17 bits total in current

            // So we can define current as 17 bits:
            // We'll redefine current width here:

            // For clarity, re-declare current width inside always to 17 bits
        end
    end

endmodule