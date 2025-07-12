module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_result;
    reg [15:0] temp_odd;
    reg [15:0] temp_dividend;
    reg [7:0] temp_divisor;
    
    temp_result = 0;
    temp_odd = a_reg;
    temp_divisor = b_reg;
    
    for (int i = 15; i >= 8; i--) begin
        if (temp_odd[15:8] >= temp_divisor) begin
            temp_result[i - 8] = 1;
            temp_odd = (temp_odd[15:8] - temp_divisor) << 8 | temp_odd[7:0];
        end else begin
            temp_odd = temp_odd[15:8] << 8 | temp_odd[7:0];
        end
    end
    
    for (int i = 7; i >= 0; i--) begin
        if (temp_odd[15:8] >= temp_divisor) begin
            temp_result[i] = 1;
            temp_odd = (temp_odd[15:8] - temp_divisor) << 8 | temp_odd[7:0];
        end else begin
            temp_odd = temp_odd[15:8] << 8 | temp_odd[7:0];
        end
    end
    
    result = temp_result;
    odd = temp_odd;
end

endmodule