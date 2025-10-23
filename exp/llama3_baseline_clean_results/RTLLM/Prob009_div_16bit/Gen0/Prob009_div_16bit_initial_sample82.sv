module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;
reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    for (int i = 15; i >= 8; i = i - 1) begin
        if (odd_reg[15:8] >= b_reg) begin
            result_reg[15 - i + 8] = 1;
            odd_reg = {odd_reg[7:0], 8'd0} - {b_reg, 8'd0};
        end else begin
            odd_reg = {odd_reg[7:0], 8'd0};
        end
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule