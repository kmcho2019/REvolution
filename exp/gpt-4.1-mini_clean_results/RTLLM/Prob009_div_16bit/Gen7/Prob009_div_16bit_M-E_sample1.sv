module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First always block: update a_reg and b_reg combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: perform division combinationally following problem approach
    always @(*) begin
        integer i;
        reg [7:0] partial_remainder;
        reg [15:0] quotient_local;
        reg [7:0] divisor_local;
        reg dividend_bit;

        // Default outputs
        quotient_local = 16'd0;
        partial_remainder = 8'd0;
        divisor_local = b_reg;

        // Handle division by zero (output zero quotient and remainder)
        if (divisor_local == 8'd0) begin
            quotient_local = 16'd0;
            partial_remainder = 8'd0;
        end else begin
            // Process each bit of dividend from MSB (bit 15) down to LSB (bit 0)
            for (i = 15; i >= 0; i = i -1) begin
                // Extract current dividend bit
                dividend_bit = a_reg[i];

                // Shift partial remainder left by 1, bring down current dividend bit
                partial_remainder = {partial_remainder[6:0], dividend_bit};

                // Compare partial remainder with divisor
                if (partial_remainder >= divisor_local) begin
                    // Subtract divisor from remainder
                    partial_remainder = partial_remainder - divisor_local;
                    // Set quotient bit to 1 at current position
                    quotient_local[i] = 1'b1;
                end else begin
                    // Quotient bit 0
                    quotient_local[i] = 1'b0;
                end
            end
        end

        // Assign outputs
        result = quotient_local;
        odd = {8'd0, partial_remainder}; // zero-extend remainder to 16 bits
    end

endmodule