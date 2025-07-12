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

    for (int i = 7; i >= 0; i = i - 1) begin
        if (i < 8) begin
            remainder = {remainder[6:0], dividend[15 - i]};
        end else begin
            remainder = {remainder[6:0], 1'b0};
        end

        if (remainder >= {8'd0, divisor}) begin
            quotient[15 - i] = 1;
            remainder = remainder - {8'd0, divisor};
        end else begin
            quotient[15 - i] = 0;
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule