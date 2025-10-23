module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers for stable inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division: restoring division algorithm
    always @(*) begin
        integer i;
        reg [8:0] remainder;      // 9 bits: 8 bits divisor + 1 for carry
        reg [15:0] quotient;

        remainder = 9'b0;
        quotient  = 16'b0;

        // Process 16 bits of dividend from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring next dividend bit into LSB
            remainder = {remainder[7:0], a_reg[i]};

            // If remainder >= divisor, subtract divisor and set quotient bit
            if (remainder[8:1] >= b_reg) begin
                remainder[8:1] = remainder[8:1] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd    = {8'b0, remainder[8:1]};  // zero-extend remainder to 16 bits
    end

endmodule