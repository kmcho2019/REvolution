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

    // Second always block: perform division combinationally
    always @(*) begin
        reg [7:0] remainder;    // 8-bit remainder
        reg [15:0] quotient;    // 16-bit quotient
        integer i;

        remainder = 8'd0;
        quotient = 16'd0;

        // Process bits from MSB (15) down to LSB (0)
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down current bit of dividend
            remainder = {remainder[6:0], a_reg[i]};
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Zero-extend remainder (8 bits) to 16 bits
        odd = {8'd0, remainder};
    end

endmodule