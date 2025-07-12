module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [7:0] remainder;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 8; i--) begin
        remainder = {dividend[i], remainder[7:1]};
        if (remainder >= divisor) begin
            quotient = quotient | (1 << (i - 8));
            remainder = remainder - divisor;
        end
    end

    for (int i = 7; i >= 0; i--) begin
        remainder = {dividend[i], remainder[7:1]};
        if (remainder >= divisor) begin
            quotient = quotient | (1 << i);
            remainder = remainder - divisor;
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule