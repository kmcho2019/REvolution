module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 8; i--) begin
        reg [15:0] temp;
        temp = dividend >> (i - 7);
        if (temp >= divisor) begin
            quotient = quotient | (1 << (i - 8));
            temp = temp - divisor;
        end
        remainder = (remainder << 1) | (temp[0]);
    end

    result = quotient;
    odd = remainder;
end

endmodule