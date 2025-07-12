module div_16bit(
    input   [15:0] A,  // 16-bit dividend
    input   [7:0]  B,  // 8-bit divisor
    output  [15:0] result,  // 16-bit quotient
    output  [15:0] odd    // 16-bit remainder
);

reg [15:0] a_reg;  // Register to hold the dividend
reg [7:0]  b_reg;  // Register to hold the divisor

// First always block: update registers with input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: perform division operation
always @(*) begin
    reg [15:0] quotient;  // Quotient
    reg [15:0] remainder;  // Remainder
    reg [7:0]  temp;       // Temporary variable

    if (b_reg == 0) begin  // Handle division by zero
        quotient = 16'd0;
        remainder = a_reg;
    end else begin
        quotient = 16'd0;
        remainder = a_reg;
        for (int i = 15; i >= 0; i = i - 1) begin
            temp = remainder[15:8];  // Extract higher bits
            if (temp >= b_reg) begin
                quotient[15 - i] = 1'b1;
                remainder = (remainder << 1) - (b_reg << 8);
            end else begin
                quotient[15 - i] = 1'b0;
                remainder = remainder << 1;
            end
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule