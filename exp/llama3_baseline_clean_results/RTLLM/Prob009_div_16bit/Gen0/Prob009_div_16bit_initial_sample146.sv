module div_16bit(
    input [15:0] A,
    input [7:0] B,
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
    reg [15:0] temp_a;
    reg [15:0] temp_result;
    temp_a = a_reg;
    temp_result = 0;
    
    for (int i = 15; i >= 8; i--) begin
        if (temp_a[15:8] >= b_reg) begin
            temp_result[i-7] = 1;
            temp_a = {temp_a[7:0], temp_a[15:8] - b_reg};
        end else begin
            temp_a = {temp_a[7:0], temp_a[15:8]};
        end
    end
    
    result = temp_result;
    odd = temp_a;
end

endmodule