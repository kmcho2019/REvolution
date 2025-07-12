module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;
reg [15:0] temp;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    for (int i = 8; i >= 0; i = i - 1) begin
        temp = odd_reg[15:8];
        if (temp > b_reg) begin
            result_reg = result_reg + (1 << i);
            odd_reg = (odd_reg[15:8] - b_reg) << 8 | odd_reg[7:0];
        end else begin
            odd_reg = odd_reg[15:8] << 8 | odd_reg[7:0];
        end
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule