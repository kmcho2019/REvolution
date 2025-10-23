module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs in combinational manner (though usually registers are sequential)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic in combinational always block
    always @(*) begin
        reg [15:0] quotient;
        reg [15:0] remainder;    // Will hold the concatenated remainder and shifted bits
        reg [7:0]  divisor;
        integer i;

        quotient = 0;
        remainder = 0;
        divisor = b_reg;

        // The algorithm extracts the highest 8 bits from the remainder+dividend concatenation,
        // compares with divisor, sets quotient bit and updates remainder.
        // Initially, remainder = 0; We process dividend bits from MSB to LSB.

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit, bring in next dividend bit
            remainder = {remainder[14:0], a_reg[i]};

            // Extract top 8 bits from remainder
            if (remainder[15:8] >= divisor) begin
                // If remainder top bits >= divisor, subtract divisor and set quotient bit
                remainder[15:8] = remainder[15:8] - divisor;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd    = remainder; // remainder is 16 bits including remainder and shifted in bits
    end

endmodule