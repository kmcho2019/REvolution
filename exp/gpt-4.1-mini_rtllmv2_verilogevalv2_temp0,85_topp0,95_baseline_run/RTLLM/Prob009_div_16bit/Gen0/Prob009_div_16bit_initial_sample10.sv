module div_16bit (
    input  wire [15:0] A,    // 16-bit dividend
    input  wire [7:0]  B,    // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Load input registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        integer i;
        reg [7:0] remainder;       // 8-bit remainder part at each step
        reg [15:0] quotient_temp;  // Temporary quotient
        reg [15:0] dividend_work;  // Working dividend portion for remainder calculation

        quotient_temp = 16'b0;
        remainder = 8'b0;
        dividend_work = a_reg;

        // Iterate through 16 bits
        // At each iteration:
        // - Shift remainder left by 1 bit and bring down next bit from dividend_work
        // - Compare remainder and divisor
        // - If remainder >= divisor, set quotient bit and subtract divisor from remainder
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[6:0], dividend_work[i]};
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient_temp[i] = 1'b1;
            end else begin
                quotient_temp[i] = 1'b0;
            end
        end

        result = quotient_temp;
        // Zero-extend remainder to 16 bits for output odd
        odd = {8'b0, remainder};
    end

endmodule