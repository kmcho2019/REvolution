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
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    temp_quotient = 0;
    temp_remainder = a_reg;
    
    for (int i = 15; i >= 7; i = i - 1) begin
        if (temp_remainder[15:8] >= b_reg) begin
            temp_quotient[15 - i] = 1;
            temp_remainder = {temp_remainder[7:0], 8'd0} - {b_reg, 8'd0};
        end else begin
            temp_quotient[15 - i] = 0;
        end
        temp_remainder = {temp_remainder[7:0], temp_remainder[15]};
    end
    
    result_reg = temp_quotient;
    odd_reg = temp_remainder;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule