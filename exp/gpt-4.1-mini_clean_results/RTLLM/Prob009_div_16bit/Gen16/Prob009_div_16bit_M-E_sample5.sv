module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Local registers to hold inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational always block: latch inputs into local regs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: perform division by shift-subtract method
    always @(*) begin
        integer i;
        reg [8:0] remainder;      // 9-bit remainder (one bit wider than divisor)
        reg [15:0] quotient;

        remainder = 9'd0;
        quotient = 16'd0;

        // Perform division over 16 iterations, MSB first
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {7'd0, remainder};  // zero-extend remainder to 16 bits, left padded with zeros
    end

endmodule