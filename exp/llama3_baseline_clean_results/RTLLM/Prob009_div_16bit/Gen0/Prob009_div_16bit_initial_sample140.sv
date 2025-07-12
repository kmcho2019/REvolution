module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] divisor;
    reg [15:0] dividend;
    reg [7:0] dividend_bits;
    integer i;

    temp_quotient = 0;
    dividend = a_reg;
    divisor = b_reg;

    for (i = 15; i >= 0; i = i - 1) begin
        if (i < 8) begin
            dividend_bits = dividend[7:0];
        end else begin
            dividend_bits = {dividend[15], dividend[14:8]};
        end

        if (dividend_bits >= divisor) begin
            temp_quotient = {1'b1, temp_quotient[14:0]};
            dividend = {dividend[6:0], 8'b0} - divisor;
        end else begin
            temp_quotient = {1'b0, temp_quotient[14:0]};
            dividend = {dividend[6:0], 8'b0};
        end
    end

    result = temp_quotient;
    odd = dividend;

end

endmodule