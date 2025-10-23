module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);
    integer i;
    reg [7:0] divisor;
    reg [15:0] dividend;
    reg [8:0] remainder;    // 9 bits to hold remainder plus one next bit
    reg [15:0] quotient;

    always @(*) begin
        divisor = B;
        dividend = A;

        // Initialize remainder with the highest 8 bits of dividend
        remainder = dividend[15:8];
        quotient = 16'b0;

        // Process each bit from bit 7 down to bit 0 of lower half dividend
        // Each iteration shifts in one bit of dividend to remainder's LSB
        for (i = 7; i >= 0; i = i -1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[7:0], dividend[i]};
            // Compare remainder with divisor
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[8 + i] = 1'b1; // quotient bits correspond to dividend bits [15:8] + i
            end else begin
                quotient[8 + i] = 1'b0;
            end
        end

        // Now process bits 7 down to 0 of dividend[7:0]
        // Shift in next dividend bits from LSB half [7:0]
        // Actually, the above loop already processed the lower 8 bits (i=7..0)
        // But quotient bits were assigned to [15:8], need to process bits [7:0] now.

        // Wait, the problem states to start from higher bits of dividend equal in width to divisor (8 bits), then for each remaining bit:
        // Actually, the dividend has 16 bits:
        // Step 1: remainder = dividend[15:8]
        // For each bit in dividend[7:0], concatenate next bit to remainder and compare with divisor
        // So quotient bits are assigned starting from bit 7 down to bit 0 (lowest bits)

        // Correcting the quotient assignment:
        // The initial remainder was dividend[15:8], quotient bits correspond to dividend bits [15:8] = first 8 bits, but these are remainder bits, quotient is built from processing the lower bits.

        // Re-implementing the algorithm accordingly:

        // Correct approach: quotient bits are bit indices from 7 down to 0, processing dividend bits 7 down to 0

        // So redo above loop:

        remainder = dividend[15:8];
        quotient = 16'b0;

        for (i = 7; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], dividend[i]};
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // The upper bits of quotient [15:8] are zero, since problem implies only processing 8 bits quotient aligned with divisor width

        // But problem states 16-bit quotient output, so for bits 15 down to 8, process quotient bits as zero

        quotient[15:8] = 8'b0;

        // Output assignments
        result = quotient;
        odd = {8'b0, remainder[7:0]}; // remainder zero-extended to 16 bits
    end

endmodule