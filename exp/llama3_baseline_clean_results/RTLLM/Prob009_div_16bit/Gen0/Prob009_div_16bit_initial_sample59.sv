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
reg [15:0] temp;
integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    for (i = 8; i < 16; i++) begin
        temp = odd_reg >> (i-8);
        if (temp >= b_reg) begin
            result_reg = result_reg | (1 << (i-8));
            odd_reg = (odd_reg - (b_reg << (i-8)));
        end
    end
    result = result_reg;
    odd = odd_reg;
end

endmodule