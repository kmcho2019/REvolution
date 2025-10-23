module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;

    quotient = 0;
    remainder = a_reg;
    divisor = b_reg;

    for (int i = 15; i >= 0; i = i - 1) begin
        if (remainder[15:8] >= divisor) begin
            quotient[15 - i] = 1;
            remainder = (remainder[15:8] - divisor) << 8 | remainder[7:0];
        end else begin
            remainder = remainder[15:8] << 8 | remainder[7:0];
        end
    end

    result = quotient;
    odd = remainder;
end

endmodule