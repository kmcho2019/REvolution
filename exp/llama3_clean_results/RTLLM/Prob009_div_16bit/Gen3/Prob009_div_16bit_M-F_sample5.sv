module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [7:0] remainder;

    dividend = A;
    divisor = B;
    quotient = 0;
    remainder = 0;

    for (int i = 8; i >= 0; i = i - 1) begin
        if ({remainder, dividend[15 - i]} >= {8'd0, divisor}) begin
            quotient = quotient | (1 << i);
            remainder = {remainder, dividend[15 - i]} - {8'd0, divisor};
        end else begin
            remainder = {remainder, dividend[15 - i]};
        end
    end

    result = quotient;
    odd = {8'd0, remainder};
end

endmodule