module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [7:0] remainder;
reg [3:0] count;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;
    count = 8;

    // Stage 1: Initialize quotient and remainder
    if (count == 8) begin
        quotient = 0;
        remainder = dividend[15:8];
    end

    // Stage 2-9: Perform division
    for (int i = 7; i >= 0; i--) begin
        if (remainder >= divisor) begin
            quotient = quotient | (1 << (7 - i));
            remainder = remainder - divisor;
        end
        remainder = {remainder[6:0], dividend[7 - i]};
    end

    result = quotient;
    odd = {8'd0, remainder};
end

endmodule