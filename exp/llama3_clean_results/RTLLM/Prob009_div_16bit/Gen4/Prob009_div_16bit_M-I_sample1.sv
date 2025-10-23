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

    for (int i = 15; i >= 8; i = i - 1) begin
        remainder = {remainder[6:0], dividend[i]};
        if (remainder >= divisor) begin
            remainder = remainder - divisor;
            quotient = quotient | (1 << (i - 8));
        end
    end

    result = quotient;
    odd = {8'd0, remainder};
end

endmodule