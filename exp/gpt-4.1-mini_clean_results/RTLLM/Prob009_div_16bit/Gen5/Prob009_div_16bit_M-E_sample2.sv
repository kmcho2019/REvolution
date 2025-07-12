module div_16bit (
    input  wire [15:0] A,      // 16-bit dividend
    input  wire [7:0]  B,      // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder (zero-extended)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    reg [7:0] remainder;        // 8-bit remainder
    reg [15:0] quotient;        // 16-bit quotient

    integer i;

    // Always block 1: latch inputs into registers (combinational as per problem)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Always block 2: combinational division process
    always @(*) begin
        remainder = a_reg[15:8]; // Extract highest 8 bits as initial remainder
        quotient = 0;

        // For each bit position from 15 down to 0 in quotient
        // We shift remainder left by 1, append next dividend bit from a_reg[7 down to 0] or zeros after 8 iterations.
        // Specifically, bits from a_reg[7:0] are shifted in during the 16 iterations.

        // Because initial remainder is bits 15:8, we process bits 7 down to 0 in the loop.

        for (i = 0; i < 16; i = i + 1) begin
            // Determine which dividend bit to shift in:
            // For i in 0..7: use bits from a_reg[7 - i]
            // For i in 8..15: no more bits left, shift in 0
            // But problem says process all bits, so to maintain alignment:
            // Actually shift in bits from MSB down to LSB starting after initial remainder bits:
            // The first shift-in bit after initial remainder is bit 7, next 6,... bit 0, then 0 for remaining iterations

            // Calculate bit to shift in
            reg bit_in;
            if (i < 8) begin
                bit_in = a_reg[7 - i];
            end else begin
                bit_in = 1'b0; // no more bits, pad with zeros
            end

            // Shift remainder left by 1 and append bit_in
            remainder = {remainder[6:0], bit_in};

            // Compare remainder and divisor
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[15 - i] = 1'b1;
            end else begin
                quotient[15 - i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder}; // Zero-extend remainder to 16 bits
    end

endmodule