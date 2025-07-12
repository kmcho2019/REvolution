module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    integer i;
    reg [15:0] remainder;
    reg [15:0] quotient;

    always @(*) begin
        remainder = 16'd0;
        quotient = 16'd0;

        if (B == 0) begin
            // Divide by zero case: output zero quotient and remainder
            quotient = 16'd0;
            remainder = 16'd0;
        end else begin
            // For each bit of dividend starting from MSB to LSB
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left by 1 and bring in next dividend bit
                remainder = remainder << 1;
                remainder[0] = A[i];

                // Extract top 8 bits of remainder for comparison
                if (remainder[15:8] >= B) begin
                    // Subtract divisor shifted into upper bits
                    remainder[15:8] = remainder[15:8] - B;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
            end
        end

        result = quotient;
        // Remainder is lower 8 bits of remainder, zero-extend to 16 bits
        odd = {8'b0, remainder[7:0]};
    end

endmodule