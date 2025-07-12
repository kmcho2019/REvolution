module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Combinational registers for inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division combinational block
    always @(*) begin
        integer i;
        reg [8:0] remainder;    // 9-bit remainder to hold up to divisor + carry
        reg [15:0] quotient;

        remainder = 9'd0;
        quotient = 16'd0;

        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder left by 1, bring down the next dividend bit
            remainder = {remainder[7:0], a_reg[15 - i]};

            // Compare remainder with divisor (9-bit remainder, 8-bit divisor zero-extended)
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[15 - i] = 1'b1;
            end else begin
                quotient[15 - i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]}; // Zero-extend remainder to 16 bits
    end

endmodule