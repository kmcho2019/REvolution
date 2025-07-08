module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Capture inputs into registers (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform division in combinational logic
    always @(*) begin
        // Variables for division process
        integer i;
        reg [15:0] quotient;
        reg [15:0] remainder;

        quotient = 0;
        remainder = 0;

        // Perform bit-by-bit division
        // We treat remainder as 16 bits so we can shift in dividend bits from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 and bring down next dividend bit
            remainder = (remainder << 1) | (a_reg[i]);

            // Extract top 8 bits of remainder for comparison
            // Note: remainder is 16 bits, divisor 8 bits
            // Compare MSB 8 bits of remainder with divisor
            // MSB 8 bits: remainder[15:8]
            if (remainder[15:8] >= b_reg) begin
                // Subtract divisor from MSB bits of remainder
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule