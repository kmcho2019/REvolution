module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    integer i;
    reg [8:0] remainder;  // 9-bit remainder to accommodate subtraction

    // Combinational division logic
    always @(*) begin
        remainder = 9'd0;
        result = 16'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left 1, bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end
        odd = {8'd0, remainder[7:0]}; // zero-extend remainder
    end

endmodule