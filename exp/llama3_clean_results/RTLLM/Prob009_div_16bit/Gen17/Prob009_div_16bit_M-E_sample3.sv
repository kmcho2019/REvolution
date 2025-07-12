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

    reg [7:0] temp_divisor;
    reg [15:0] temp_dividend;

    temp_divisor = divisor;
    temp_dividend = dividend;

    for (int i = 15; i >= 8; i--) begin
        if (temp_dividend[15:8] >= temp_divisor) begin
            quotient = quotient | (1 << i);
            temp_dividend[15:8] = temp_dividend[15:8] - temp_divisor;
        end
        temp_dividend = {temp_dividend[7:0], 8'd0};
    end

    for (int i = 7; i >= 0; i--) begin
        if (temp_dividend[7:0] >= temp_divisor) begin
            quotient = quotient | (1 << i);
            temp_dividend[7:0] = temp_dividend[7:0] - temp_divisor;
        end
    end

    result = quotient;
    odd = {8'd0, temp_dividend[7:0]};
end

endmodule