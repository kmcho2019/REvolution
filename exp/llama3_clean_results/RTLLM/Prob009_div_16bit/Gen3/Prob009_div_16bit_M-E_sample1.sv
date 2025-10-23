module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] temp;

    dividend = A;
    divisor = B;
    quotient = 0;

    for (int i = 15; i >= 7; i--) begin
        temp = dividend >> i;
        if (temp >= divisor) begin
            quotient = quotient + (1 << (i-7));
            dividend = dividend - (divisor << i);
        end
    end

    result = quotient;
    odd = dividend;
end

endmodule