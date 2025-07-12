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
    reg [15:0] temp_odd;
    reg [15:0] temp_result;
    temp_odd = a_reg;
    temp_result = 0;
    for (int i = 8; i >= 0; i--) begin
        if (temp_odd[15 - i +: 8] >= b_reg) begin
            temp_result = temp_result << 1;
            temp_result[0] = 1;
            temp_odd = {temp_odd[15 - i - 8 +: 8], temp_odd[7:0]} - b_reg;
        end else begin
            temp_result = temp_result << 1;
            temp_odd = {temp_odd[15 - i - 8 +: 8], temp_odd[7:0]};
        end
    end
    result_reg = temp_result;
    odd_reg = temp_odd;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule