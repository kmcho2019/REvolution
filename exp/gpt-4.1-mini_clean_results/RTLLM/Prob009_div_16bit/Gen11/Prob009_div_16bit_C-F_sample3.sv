module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // First always block: combinationally latch inputs into registers (minimal logic as requested)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    integer i;
    reg [8:0] remainder;          // 9-bit remainder to detect borrow easily
    reg [15:0] quotient;

    always @(*) begin
        remainder = 9'd0;
        quotient = 16'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 and bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Subtract divisor extended to 9 bits from remainder
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        result = quotient;
        odd = {8'd0, remainder[7:0]};  // zero-extend 8-bit remainder to 16 bits
    end

endmodule