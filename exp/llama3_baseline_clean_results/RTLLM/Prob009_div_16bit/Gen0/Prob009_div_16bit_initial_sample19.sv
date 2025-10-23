module div_16bit(
    input [15:0] A, // 16-bit dividend
    input [7:0] B,  // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd    // 16-bit remainder
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

    divisor = b_reg;
    temp_quotient = 0;
    temp_remainder = a_reg;

    for (int i = 15; i >= 8; i--) begin
        if (temp_remainder[15:8] >= divisor) begin
            temp_quotient[15-i+7] = 1;
            temp_remainder = {temp_remainder[7:0], 8'd0} - {divisor, 8'd0};
        end else begin
            temp_quotient[15-i+7] = 0;
        end
        temp_remainder = {temp_remainder[7:0], temp_remainder[15]};
    end

    for (int i = 7; i >= 0; i--) begin
        if (temp_remainder[15:8] >= divisor) begin
            temp_quotient[7-i] = 1;
            temp_remainder = {temp_remainder[7:0], 8'd0} - {divisor, 8'd0};
        end else begin
            temp_quotient[7-i] = 0;
        end
        temp_remainder = {temp_remainder[7:0], temp_remainder[7]};
    end

    result = temp_quotient;
    odd = temp_remainder;
end

endmodule