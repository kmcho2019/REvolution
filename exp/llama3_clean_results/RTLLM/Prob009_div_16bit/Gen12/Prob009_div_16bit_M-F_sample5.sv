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

    for (int i = 8; i >= 0; i--) begin
        if (dividend >= (divisor << i)) begin
            quotient = quotient | (1 << i);
            dividend = dividend - (divisor << i);
        end
    end

    result = quotient;
    odd = dividend;
end

endmodule