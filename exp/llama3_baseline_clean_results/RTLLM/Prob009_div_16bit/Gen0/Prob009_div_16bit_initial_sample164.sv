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
reg [15:0] quotient;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    result_reg = 0;
    odd_reg = a_reg;
    quotient = 0;
    temp = 0;
    
    for (int i = 15; i >= 0; i = i - 1) begin
        temp = {odd_reg[15], odd_reg[14:1]};
        if (temp >= b_reg) begin
            quotient = {quotient[14:0], 1'b1};
            odd_reg = {odd_reg[13:0], 1'b0};
            odd_reg = odd_reg - b_reg;
        end else begin
            quotient = {quotient[14:0], 1'b0};
            odd_reg = {odd_reg[13:0], 1'b0};
        end
        odd_reg = {odd_reg[14:0], a_reg[i]};
    end
    
    result = quotient;
    odd = odd_reg;
end

endmodule