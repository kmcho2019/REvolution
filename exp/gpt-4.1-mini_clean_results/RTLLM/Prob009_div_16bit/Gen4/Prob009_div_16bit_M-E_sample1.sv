module div_16bit (
    input  wire [15:0] A,      // 16-bit dividend
    input  wire [7:0]  B,      // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder (zero-extended)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Intermediate registers for division
    reg [7:0] remainder;
    reg [15:0] quotient;

    integer i;

    // First always block: latch inputs into internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: perform combinational division using shift-subtract method
    always @(*) begin
        remainder = a_reg[15:8]; // Initialize remainder with the top 8 bits of A
        quotient = 0;

        // For each bit position from MSB to LSB (16 bits)
        // We process bits from A[15] down to A[0]
        // Since remainder is 8 bits, before comparing with divisor,
        // we shift remainder left by 1 and bring in next dividend bit from a_reg.

        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder left by 1 bit and bring in next dividend bit
            remainder = {remainder[6:0], a_reg[15 - i]};

            // Compare remainder and divisor
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[15 - i] = 1'b1;
            end else begin
                quotient[15 - i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder}; // Zero-extend 8-bit remainder to 16 bits
    end

endmodule