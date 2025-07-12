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
reg [3:0] count;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;
    count = 0;

    for (count = 0; count < 16; count = count + 1) begin
        remainder = {remainder[7:0], dividend[15]};
        if (remainder >= {8'd0, divisor}) begin
            quotient = quotient | (1 << (15 - count));
            remainder = remainder - {8'd0, divisor};
        end
        dividend = {dividend[14:0], 1'b0};
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule