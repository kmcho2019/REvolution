module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] temp;
reg [3:0] i;

always @(A or B) begin
    a_reg = A;
    b_reg = B;
end

always @(A or B) begin
    result = 0;
    odd = 0;
    temp = a_reg;
    for (i = 8; i < 16; i++) begin
        if (temp[15-i+7:15-i] >= b_reg) begin
            result[i-8] = 1;
            temp = (temp << 1) - b_reg;
        end else begin
            result[i-8] = 0;
            temp = temp << 1;
        end
    end
    odd = temp;
end

endmodule