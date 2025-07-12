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
    reg [15:0] temp;
    reg [7:0] temp_divisor;
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;

    temp = a_reg;
    temp_divisor = b_reg;
    temp_quotient = 0;
    temp_remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        temp_remainder = {temp_remainder[14:0], 1'b0};
        temp_remainder[15:8] = temp[15:8];
        if (temp_remainder >= temp_divisor) begin
            temp_quotient[15 - i] = 1'b1;
            temp_remainder = temp_remainder - temp_divisor;
        end
        temp = temp << 1;
    end

    result_reg = {8'd0, temp_quotient[7:0]};
    odd_reg = {8'd0, temp_remainder[7:0]};
end

assign result = result_reg;
assign odd = odd_reg;

endmodule