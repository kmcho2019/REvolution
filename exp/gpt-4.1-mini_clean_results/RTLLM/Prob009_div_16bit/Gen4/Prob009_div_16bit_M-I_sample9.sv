module div_16bit (
    input  wire [15:0] A,    // Dividend
    input  wire [7:0]  B,    // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (zero-extended)
);

    integer i;
    reg [7:0] remainder;
    reg [15:0] quotient;

    always @(*) begin
        quotient = 16'd0;
        remainder = A[15:8]; // Start with highest 8 bits of dividend as initial remainder

        if (B == 8'd0) begin
            // Division by zero: set outputs zero as defined
            quotient = 16'd0;
            remainder = 8'd0;
        end else begin
            // Perform division bit-by-bit starting at bit 8 down to 0
            // Each iteration: compare remainder and divisor,
            // set quotient bit accordingly,
            // subtract divisor if possible,
            // then shift in next dividend bit from A[7:0]
            for (i = 8; i >= 0; i = i - 1) begin
                if (remainder >= B) begin
                    remainder = remainder - B;
                    quotient[i + 7] = 1'b1; 
                end else begin
                    quotient[i + 7] = 1'b0;
                end
                // Shift left remainder by 1 and bring in next dividend bit
                if (i > 0)
                    remainder = {remainder[6:0], A[i - 1]};
            end
            // Handle the last 7 bits of quotient (bits 6 downto 0):
            // These correspond to the lower bits of A shifted down as quotient bits,
            // We fill them with 0 since the division only explicitly calculates quotient bits 15 down to 8 + 0 (9 bits).
            // So zero out bits [6:0] to maintain consistency
            quotient[6:0] = 7'b0;
        end

        result = quotient;
        odd = {8'b0, remainder}; // Zero-extend remainder to 16 bits for output
    end

endmodule