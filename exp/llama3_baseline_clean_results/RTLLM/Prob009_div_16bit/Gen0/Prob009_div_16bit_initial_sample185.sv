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
    reg [15:0] temp_result;
    reg [7:0] temp_odd;
    reg [15:0] temp_shift;
    temp = a_reg;
    temp_result = 0;
    for (int i = 15; i >= 8; i = i - 1) begin
        if (temp[15:8] > b_reg) begin
            temp_result = temp_result << 1;
            temp_result[0] = 1;
            temp[15:8] = temp[15:8] - b_reg;
        end else begin
            temp_result = temp_result << 1;
        end
        temp = {temp[7:0], temp[15]};
    end
    temp_result = temp_result << 8;
    for (int i = 7; i >= 0; i = i - 1) begin
        if ({temp[7:0], 1'b0} >= b_reg) begin
            temp_result = temp_result << 1;
            temp_result[0] = 1;
            temp[7:0] = {temp[7:0], 1'b0} - b_reg;
        end else begin
            temp_result = temp_result << 1;
        end
    end
    result_reg = temp_result;
    odd_reg = temp;
end

assign result = result_reg;
assign odd = odd_reg;

endmodule