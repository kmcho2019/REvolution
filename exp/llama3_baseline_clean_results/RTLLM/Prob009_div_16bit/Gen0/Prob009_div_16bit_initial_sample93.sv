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
    reg [7:0] divisor;
    reg [15:0] dividend;
    reg [15:0] quotient;
    reg [7:0] remainder;
    reg [15:0] temp;
    integer i;

    dividend = a_reg;
    divisor = b_reg;
    quotient = 0;
    remainder = 0;

    for (i = 15; i >= 0; i = i - 1) begin
        temp = {remainder, dividend[15]};
        remainder = temp[7:0];
        if (temp[15:8] >= divisor) begin
            quotient = {quotient[14:0], 1'b1};
            remainder = temp[15:8] - divisor;
        end else begin
            quotient = {quotient[14:0], 1'b0};
        end
        dividend = {dividend[14:0], 1'b0};
    end

    result_reg = quotient;
    odd_reg = {8'b0, remainder};
end

assign result = result_reg;
assign odd = odd_reg;

endmodule