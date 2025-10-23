module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

reg [15:0] temp_quotient;
reg [15:0] temp_remainder;
reg [15:0] temp_a;

always @(*) begin
    temp_quotient = 0;
    temp_remainder = a_reg;
    temp_a = a_reg;

    for (int i = 15; i >= 8; i--) begin
        if (temp_a[15:8] >= b_reg) begin
            temp_quotient[15-i+7] = 1;
            temp_remainder = (temp_a[15:8] - b_reg) << 8 | temp_a[7:0];
        end else begin
            temp_quotient[15-i+7] = 0;
            temp_remainder = temp_a;
        end
        temp_a = temp_remainder;
    end

    result = temp_quotient;
    odd = temp_remainder[7:0];
end

endmodule