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
reg [7:0] temp_remainder;
reg [15:0] temp_quotient;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    temp_quotient = 0;
    temp_remainder = a_reg[15:8];
    for (int i = 7; i >= 0; i--) begin
        if (temp_remainder >= b_reg) begin
            temp_quotient = {temp_quotient[14:0], 1'b1};
            temp_remainder = temp_remainder - b_reg;
        end else begin
            temp_quotient = {temp_quotient[14:0], 1'b0};
        end
        temp_remainder = {temp_remainder[6:0], a_reg[i]};
    end
    result_reg = temp_quotient;
    odd_reg = {8'd0, temp_remainder};
    result = result_reg;
    odd = odd_reg;
end

endmodule