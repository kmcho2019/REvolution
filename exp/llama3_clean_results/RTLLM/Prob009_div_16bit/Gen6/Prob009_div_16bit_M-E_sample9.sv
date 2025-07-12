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
reg [7:0] temp;

always @(*) begin
    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;

    for (int i = 7; i >= 0; i = i - 1) begin
        temp = {remainder, dividend[15 + i]};
        if (temp >= {8'd0, divisor}) begin
            quotient[15 - i] = 1;
            remainder = temp - {8'd0, divisor};
        end else begin
            quotient[15 - i] = 0;
            remainder = temp;
        end
    end

    result = quotient;
    odd = {8'd0, remainder};
end

endmodule