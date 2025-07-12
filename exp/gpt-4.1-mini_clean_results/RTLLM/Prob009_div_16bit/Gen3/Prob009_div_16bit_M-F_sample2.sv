module div_16bit (
    input  wire [15:0] A,      // 16-bit dividend
    input  wire [7:0]  B,      // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder (zero-extended)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational block to latch inputs into registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational block performs the division as described
    always @(*) begin
        // Variables:
        // dividend_part: current portion of dividend, width = divisor width (8 bits)
        // quotient_reg: accumulates quotient bits
        // remainder: remainder at each step (width = divisor width, 8 bits)
        // i: loop index for bits processed

        reg [7:0] dividend_part;
        reg [15:0] quotient_reg;
        reg [7:0] remainder;
        integer i;

        quotient_reg = 0;
        remainder = 0;

        // Initially take the top 8 bits of dividend as dividend_part
        dividend_part = a_reg[15:8];

        // Process 16 bits one by one, matching the problem's iterative method:
        // At each step:
        // - Compare dividend_part with divisor
        // - Set quotient bit accordingly
        // - Update remainder (difference if dividend_part >= divisor, else dividend_part)
        // - Concatenate remainder (8 bits) with next dividend bit to form new dividend_part
        //
        // The next dividend bit index goes from 7 down to 0 (16 bits total, after initial 8 bits)

        for (i = 0; i < 16; i = i + 1) begin
            // Compare dividend_part with divisor
            if (dividend_part >= b_reg) begin
                quotient_reg[15 - i] = 1'b1;
                remainder = dividend_part - b_reg;
            end else begin
                quotient_reg[15 - i] = 1'b0;
                remainder = dividend_part;
            end

            // Prepare dividend_part for next iteration
            // Shift remainder left by 1 bit and concatenate next dividend bit if exists
            if (i < 15) begin
                // Next bit from a_reg: bit index = 7 - i (since we started with bits 15:8)
                // For i=0 => next bit is a_reg[7], for i=1 => a_reg[6], ..., i=7 => a_reg[0], then for i>7 no bits left, pad 0
                // But total bits: 16, we started with top 8 bits, so next bits are a_reg[7:0], iterate accordingly
                dividend_part = {remainder[6:0], a_reg[7 - i]};
            end else begin
                // Last iteration, no more bits to bring down, just shift remainder left by 1 pad 0
                dividend_part = {remainder[6:0], 1'b0};
            end
        end

        result = quotient_reg;
        odd = {8'b0, remainder};  // zero-extend remainder to 16 bits
    end

endmodule