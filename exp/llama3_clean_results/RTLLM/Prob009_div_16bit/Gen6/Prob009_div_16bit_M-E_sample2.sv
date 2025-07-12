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

    for (int i = 15; i >= 0; i--) begin
        if (dividend >= {8'd0, divisor}) begin
            dividend = dividend - {8'd0, divisor};
            quotient = quotient + (1 << i);
        end
    end

    result = quotient;
    odd = dividend;
end

endmodule