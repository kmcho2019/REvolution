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
        if (dividend >= ({divisor, 8'd0} << i)) begin
            quotient = quotient | (1 << (i - 8));
            dividend = dividend - ({divisor, 8'd0} << i);
        end
    end

    for (int i = 7; i >= 0; i--) begin
        if (dividend >= ({divisor, {8'd0, i{1'b0}}} )) begin
            quotient = quotient | (1 << i);
            dividend = dividend - ({divisor, {8'd0, i{1'b0}}});
        end
    end

    result = quotient;
    odd = {8'd0, dividend};
end

endmodule