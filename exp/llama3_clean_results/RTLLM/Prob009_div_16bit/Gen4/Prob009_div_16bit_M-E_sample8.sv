module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [7:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    temp_result = 0;
    temp_odd = a_reg;
    for (int i = 15; i >= 8; i = i - 1) begin
        reg [15:0] sub_result;
        sub_result = temp_odd[15:8] - b_reg;
        if (sub_result >= 0) begin
            temp_result[15-i] = 1;
            temp_odd[15:8] = sub_result;
        end else begin
            temp_result[15-i] = 0;
        end
        temp_odd = {temp_odd[7:0], 8'b0} | temp_odd[15:8];
    end
    for (int i = 7; i >= 0; i = i - 1) begin
        reg [15:0] sub_result;
        sub_result = temp_odd[7:0] - b_reg;
        if (sub_result >= 0) begin
            temp_result[7-i] = 1;
            temp_odd[7:0] = sub_result;
        end else begin
            temp_result[7-i] = 0;
        end
        temp_odd = {temp_odd[7:0], 8'b0};
    end
    result = temp_result;
    odd = temp_odd[7:0];
end

endmodule