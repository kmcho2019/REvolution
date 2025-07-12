module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
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
    for (integer i = 15; i >= 0; i = i - 1) begin
        if (i >= 8) begin
            if (temp_odd[15:8] >= b_reg) begin
                temp_result[15-i] = 1;
                temp_odd = ({temp_odd[15:8] - b_reg, 8'b0} | temp_odd[7:0]);
            end else begin
                temp_odd = {temp_odd[7:0], 1'b0};
            end
        end else begin
            if (temp_odd[7:0] >= b_reg) begin
                temp_result[7-i] = 1;
                temp_odd[7:0] = temp_odd[7:0] - b_reg;
            end else begin
                temp_odd = {temp_odd[7:0], 1'b0};
            end
        end
    end
    result = temp_result;
    odd = temp_odd;
end

endmodule