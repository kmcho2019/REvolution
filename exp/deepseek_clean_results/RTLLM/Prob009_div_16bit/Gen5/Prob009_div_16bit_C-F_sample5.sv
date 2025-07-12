module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [16:0] dividend_rem;  // 17 bits for remainder calculation (16 + carry)
    reg [15:0] dividend_quot; // 16 bits for quotient
    reg [7:0] divisor;
    integer i;

    always @(*) begin
        // Initialize registers
        dividend_rem = {1'b0, A[15:0]}; // 17-bit (carry + 16 bits)
        dividend_quot = 16'b0;
        divisor = B;

        // Division by zero check
        if (divisor == 8'b0) begin
            result = 16'b0;
            odd = 16'b0;
        end else begin
            // Non-restoring division algorithm
            for (i = 0; i < 16; i = i + 1) begin
                // Shift dividend left by 1
                dividend_rem = dividend_rem << 1;
                dividend_quot = dividend_quot << 1;

                // Compare upper bits (dividend_rem[16:9]) with divisor
                if (dividend_rem[16:9] >= divisor) begin
                    dividend_rem[16:9] = dividend_rem[16:9] - divisor;
                    dividend_quot[0] = 1'b1;  // Set quotient bit
                end else begin
                    dividend_quot[0] = 1'b0;  // Clear quotient bit
                end
            end

            // Assign outputs
            result = dividend_quot;
            odd = {8'b0, dividend_rem[16:9]}; // Zero-extend to 16 bits
        end
    end

endmodule