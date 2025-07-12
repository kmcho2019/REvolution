module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] temp;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [7:0] divisor;
    reg [15:0] dividend;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] shift;

    divisor = b_reg;
    dividend = a_reg;
    quotient = 0;
    remainder = 0;
    shift = 8;

    for (int i = 15; i >= 0; i--) begin
        if (i < 8) begin
            remainder = {remainder[14:0], dividend[i]};
        end
        if (remainder[15:8] >= divisor) begin
            quotient = {quotient[14:0], 1'b1};
            remainder = {remainder[14:0], remainder[7:0] - divisor};
        end else begin
            quotient = {quotient[14:0], 1'b0};
        end
    end
    result = quotient;
    odd = remainder;
end

endmodule