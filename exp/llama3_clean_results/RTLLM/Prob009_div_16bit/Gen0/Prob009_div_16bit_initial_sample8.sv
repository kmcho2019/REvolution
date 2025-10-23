module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*)
begin
    a_reg = A;
    b_reg = B;
end

always @(*)
begin
    reg [15:0] dividend;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] divisor;
    reg [7:0] temp;

    dividend = a_reg;
    divisor = b_reg;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 8; i--)
    begin
        temp = dividend[i-:8];
        if (temp >= divisor)
        begin
            quotient = quotient << 1;
            quotient[0] = 1;
            remainder = temp - divisor;
        end
        else
        begin
            quotient = quotient << 1;
            remainder = temp;
        end
        dividend = {remainder, dividend[7:0]};
    end

    // process the last 8 bits
    if (dividend >= divisor)
    begin
        quotient = quotient << 1;
        quotient[0] = 1;
        remainder = dividend - divisor;
    end
    else
    begin
        quotient = quotient << 1;
        remainder = dividend;
    end

    result = quotient;
    odd = remainder;
end

endmodule