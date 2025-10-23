module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder zero-extended
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Stage 1: Capture inputs into registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Stage 2: Combinational division process
    always @(*) begin
        reg [7:0] remainder;        // 8-bit remainder
        integer i;
        remainder = 8'd0;
        result = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring down current dividend bit
            remainder = {remainder[6:0], a_reg[i]};
            // Compare remainder with divisor
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end

        odd = {8'd0, remainder}; // zero-extend remainder to 16 bits
    end

endmodule