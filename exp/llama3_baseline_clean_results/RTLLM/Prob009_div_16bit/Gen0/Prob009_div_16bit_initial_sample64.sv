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
    result_reg = 0;
    odd_reg = a_reg;
    for (int i = 15; i >= 7; i--) begin
        reg [15:0] temp;
        reg [7:0] high_bits;
        high_bits = odd_reg[15:8];
        if (high_bits >= b_reg) begin
            temp = (odd_reg - (b_reg << (i - 7)));
            result_reg = result_reg | (1 << (i - 7));
            odd_reg = {temp[7:0], odd_reg[7:0]};
        end else begin
            odd_reg = {odd_reg[15:8], odd_reg[7:0]};
        end
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule