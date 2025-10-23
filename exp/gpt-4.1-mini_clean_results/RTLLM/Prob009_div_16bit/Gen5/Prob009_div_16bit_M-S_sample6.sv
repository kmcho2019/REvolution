module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    reg [23:0] dividend_remainder; // upper 16: dividend bits, lower 8: remainder accumulator
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        dividend_remainder = {A, 8'd0}; // append 8 zero bits for remainder start
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Extract top 8 bits (bits 23 down to 16) to compare with divisor
            if (dividend_remainder[23:16] >= B) begin
                quotient[i] = 1'b1;
                // Subtract divisor from upper 8 bits
                dividend_remainder[23:16] = dividend_remainder[23:16] - B;
            end else begin
                quotient[i] = 1'b0;
            end
            // Shift left by 1: bring next dividend bit into remainder area
            dividend_remainder = dividend_remainder << 1;
        end

        result = quotient;
        // remainder is in bits [23:16], zero-extend to 16 bits at output odd
        odd = {8'd0, dividend_remainder[23:16]};
    end

endmodule