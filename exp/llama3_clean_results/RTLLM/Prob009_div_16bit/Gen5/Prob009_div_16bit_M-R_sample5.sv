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

reg [15:0] temp_result;
reg [15:0] temp_odd;

always @(*) begin
    temp_result = 0;
    temp_odd = a_reg;
    for (int i = 15; i >= 0; i--) begin
        reg [7:0] temp;
        if (i >= 8) begin
            temp = temp_odd[15:8];
        end else begin
            temp = {temp_odd[15-i:8-i], 8'b0};
        end
        if (temp >= b_reg) begin
            temp_result[15-i] = 1;
            if (i >= 8) begin
                temp_odd = {temp - b_reg, temp_odd[7:0]};
            end else begin
                temp_odd = {8'b0, temp - b_reg};
            end
        end else begin
            if (i >= 8) begin
                temp_odd = {temp, temp_odd[7:0]} << 1;
            end else begin
                temp_odd = {8'b0, temp} << 1;
            end
        end
    end
    result = temp_result;
    odd = temp_odd;
end

endmodule