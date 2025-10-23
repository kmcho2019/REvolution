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
reg [3:0] count;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    count = 15;
    while (count > 7) begin
        if (odd_reg[15:8] >= b_reg) begin
            result_reg[count - 8] = 1'b1;
            odd_reg = {odd_reg[7:0], 8'd0} + (odd_reg[15:8] - b_reg);
        end else begin
            result_reg[count - 8] = 1'b0;
            odd_reg = {odd_reg[7:0], 8'd0} + odd_reg[15:8];
        end
        count = count - 1;
    end
    while (count >= 0) begin
        if (odd_reg[15:8] >= b_reg) begin
            result_reg[count - 8] = 1'b1;
            odd_reg = {odd_reg[7:0], 8'd0} + (odd_reg[15:8] - b_reg);
        end else begin
            result_reg[count - 8] = 1'b0;
            odd_reg = {odd_reg[7:0], 8'd0} + odd_reg[15:8];
        end
        count = count - 1;
    end
    result = result_reg;
    odd = {8'd0, odd_reg[7:0]};
end

endmodule