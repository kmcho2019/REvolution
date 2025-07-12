module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    integer i;
    reg [15:0] dividend_tmp;
    reg [7:0]  remainder;
    reg [15:0] quotient_tmp;

    // Stage 1: Register inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Stage 2: Division logic combinationally
    always @(*) begin
        quotient_tmp = 16'd0;
        remainder = 8'd0;
        dividend_tmp = a_reg;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in next dividend bit
            remainder = {remainder[6:0], dividend_tmp[i]};
            // Compare remainder with divisor
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        // zero-extend remainder to 16 bits for output
        odd = {8'd0, remainder};
    end

endmodule