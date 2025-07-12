module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [7:0] temp;
    reg [15:0] remainder;
    reg [15:0] quotient;
    reg [15:0] temp_quotient;
    reg [7:0] divisor;

    quotient = 0;
    remainder = a_reg;
    divisor = b_reg;

    for (int i = 15; i >= 8; i--) begin
        if (remainder[15:8] >= divisor) begin
            temp = remainder[15:8] - divisor;
            quotient[15 - i] = 1;
        end else begin
            temp = remainder[15:8];
            quotient[15 - i] = 0;
        end

        remainder = {temp, remainder[7:0]};
    end

    for (int i = 7; i >= 0; i--) begin
        if (remainder[7:0] >= divisor) begin
            temp = remainder[7:0] - divisor;
            quotient[7 - i] = 1;
        end else begin
            temp = remainder[7:0];
            quotient[7 - i] = 0;
        end

        remainder = {temp, 1'b0};
    end

    result_reg = quotient;
    odd_reg = remainder;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule