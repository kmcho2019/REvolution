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
    reg [15:0] temp_dividend;
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] divisor;

    temp_dividend = a_reg;
    temp_quotient = 0;
    divisor = b_reg;

    for (int i = 15; i >= 0; i--) begin
        if (temp_dividend[15:8] >= divisor) begin
            temp_quotient[15 - i] = 1'b1;
            temp_dividend = (temp_dividend[15:8] - divisor) << 8 | temp_dividend[7:0];
        end else begin
            temp_quotient[15 - i] = 1'b0;
            temp_dividend = temp_dividend[15:8] << 8 | temp_dividend[7:0];
        end
    end

    result_reg = temp_quotient;
    odd_reg = {8'd0, temp_dividend[7:0]};
end

assign result = result_reg;
assign odd = odd_reg;

endmodule