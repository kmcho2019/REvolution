module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (zero-extended)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        reg [7:0] remainder;          // remainder variable 8 bits wide
        reg [15:0] quotient;          // quotient 16 bits
        integer i;

        // Initialize:
        // Extract highest 8 bits of dividend as initial remainder
        remainder = a_reg[15:8];
        quotient = 16'd0;

        // Process bits from 7 down to 0
        // For each bit:
        // 1. Compare remainder and divisor
        // 2. Set quotient bit accordingly
        // 3. Update remainder (subtract if >= divisor)
        // 4. Shift left remainder by 1, append next dividend bit
        for (i = 7; i >= 0; i = i - 1) begin
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i + 8] = 1'b1; // quotient bits [15:8]
            end else begin
                quotient[i + 8] = 1'b0;
            end

            // Shift left remainder by 1, insert next dividend bit a_reg[i]
            remainder = {remainder[6:0], a_reg[i]};
        end

        // After processing bits [7:0], process top bits [15:8]
        // This is the initial remainder, which corresponds to quotient bits [7:0]
        // Now process highest bits [7:0]:
        for (i = 7; i >= 0; i = i - 1) begin
            // Compare remainder and divisor again
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1; // quotient bits [7:0]
            end else begin
                quotient[i] = 1'b0;
            end

            // No next dividend bits to append now, so just shift remainder left by 1 and append 0
            // Because all bits from dividend are consumed
            remainder = {remainder[6:0], 1'b0};
        end

        result = quotient;
        odd = {8'd0, remainder}; // zero-extend remainder to 16 bits
    end
endmodule