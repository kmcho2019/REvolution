module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] temp;
reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    temp = 0;
    result_reg = 0;
    odd_reg = 0;
    
    for (int i = 15; i >= 0; i--) begin
        temp = {odd_reg[15:8], a_reg[15 - i]};
        
        if (temp >= b_reg) begin
            result_reg[15 - i] = 1;
            odd_reg = temp - b_reg;
        end else begin
            result_reg[15 - i] = 0;
            odd_reg = temp;
        end
    end
    
    result = result_reg;
    odd = odd_reg;
end

endmodule