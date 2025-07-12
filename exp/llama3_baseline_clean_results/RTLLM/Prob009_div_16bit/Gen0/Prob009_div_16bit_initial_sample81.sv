module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd // 16-bit remainder
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
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [7:0] higher_bits;

    temp_quotient = 0;
    dividend = a_reg;
    divisor = b_reg;

    for (int i = 15; i >= 0; i = i - 1) begin
        if (i < 8) begin
            higher_bits = temp_remainder[7:0];
        end else begin
            higher_bits = {dividend[15:8], temp_remainder[7:1]};
        end

        if (higher_bits >= divisor) begin
            temp_quotient = {temp_quotient[14:0], 1'b1};
            temp_remainder = higher_bits - divisor;
        end else begin
            temp_quotient = {temp_quotient[14:0], 1'b0};
            temp_remainder = higher_bits;
        end

        if (i > 0) begin
            dividend = {dividend[14:0], 1'b0};
            temp_remainder = {temp_remainder[6:0], dividend[15]};
        end
    end

    result = temp_quotient;
    odd = temp_remainder;
end

endmodule