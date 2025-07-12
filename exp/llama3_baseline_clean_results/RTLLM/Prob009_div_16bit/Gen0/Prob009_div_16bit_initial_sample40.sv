module div_16bit(
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
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] tmp;
    integer i;

    dividend = a_reg;
    divisor = b_reg;
    quotient = 0;
    remainder = 0;

    for(i = 15; i >= 8; i--) begin
        tmp = dividend >> (i - 7);
        if(tmp >= divisor) begin
            quotient = quotient + (1 << (i - 8));
            remainder = tmp - divisor;
        end else begin
            remainder = tmp;
        end
        dividend = (remainder << 1) | (dividend << 1 >> 1);
    end

    for(i = 7; i >= 0; i--) begin
        remainder = remainder << 1;
        if(dividend >> i == 1) begin
            remainder = remainder + 1;
        end
        if(remainder >= divisor) begin
            quotient = quotient + (1 << i);
            remainder = remainder - divisor;
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule