module div_16bit (
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational block to latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational block to perform division
    always @(*) begin
        integer i;
        reg [7:0] remainder;
        reg [15:0] quotient;
        reg [8:0] remainder_shifted; // 9 bits to hold remainder << 1 + new bit

        remainder = 8'b0;
        quotient = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, insert next dividend bit in LSB
            remainder_shifted = {remainder, a_reg[i]};

            if (remainder_shifted[8:1] >= b_reg) begin
                // Subtract divisor from shifted remainder (bits [8:1])
                remainder = remainder_shifted[8:1] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                remainder = remainder_shifted[8:1];
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder}; // zero-extend remainder to 16 bits
    end

endmodule