module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [31:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [16:0] remainder;
integer i;

always @(*) begin
    // Initialize registers
    dividend = {16'b0, A};
    divisor = B;
    quotient = 16'b0;
    remainder = 17'b0;

    // Division by zero check
    if (divisor == 8'b0) begin
        result = 16'b0;
        odd = 16'b0;
    end else begin
        // Non-restoring division algorithm
        for (i = 0; i < 16; i = i + 1) begin
            // Shift dividend and quotient left by 1
            dividend = dividend << 1;
            quotient = quotient << 1;

            // Subtract divisor from upper bits
            remainder = {1'b0, dividend[31:16]} - {1'b0, divisor};

            if (remainder[16] == 1'b0) begin
                // If result is positive
                dividend[31:16] = remainder[15:0];
                quotient[0] = 1'b1;
            end else begin
                // If result is negative, restore and set quotient bit to 0
                // (quotient bit already 0 from shift)
                dividend[31:16] = dividend[31:16];
            end
        end

        // Assign outputs
        result = quotient;
        odd = dividend[31:16];
    end
end

endmodule