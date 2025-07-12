module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] divisor;
    reg [7:0] dividend_bits;

    divisor = b_reg;
    temp_quotient = 0;
    temp_remainder = 0;

    for (int i = 15; i >= 8; i--) begin
        dividend_bits = a_reg >> (i - 7);
        if (dividend_bits >= divisor) begin
            temp_quotient = temp_quotient | (1 << (i - 8));
            temp_remainder = dividend_bits - divisor;
        end else begin
            temp_remainder = dividend_bits;
        end
        a_reg = (a_reg << 8) | (temp_remainder << (i - 7));
    end

    for (int i = 7; i >= 0; i--) begin
        if (a_reg >= divisor) begin
            temp_quotient = temp_quotient | (1 << i);
            a_reg = a_reg - divisor;
        end
    end

    result = temp_quotient;
    odd = a_reg;
end

endmodule