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

always @(A or B) begin
    a_reg = A;
    b_reg = B;
end

always @(a_reg or b_reg) begin
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    reg [7:0] divisor;
    reg [15:0] dividend;
    reg [15:0] quotient;
    reg [15:0] remainder;

    temp_result = 0;
    temp_odd = 0;
    divisor = b_reg;
    dividend = a_reg;
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i = i - 1) begin
        if (i >= 8) begin
            remainder = {dividend[15], remainder[14:0]};
            if (remainder[15:8] >= divisor) begin
                quotient = {quotient[14:0], 1'b1};
                remainder = remainder[15:8] - divisor;
            end else begin
                quotient = {quotient[14:0], 1'b0};
            end
            dividend = dividend[14:0];
        end else begin
            remainder = {1'b0, remainder[14:0]};
            if ({remainder[7:0], dividend[15:8]} >= divisor) begin
                quotient[7:0] = {quotient[6:0], 1'b1};
                remainder = {remainder[7:0], dividend[15:8]} - divisor;
            end else begin
                quotient[7:0] = {quotient[6:0], 1'b0};
            end
            dividend = dividend[7:0];
        end
    end

    result_reg = quotient;
    odd_reg = remainder;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule