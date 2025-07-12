module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*)
begin
    a_reg = A;
    b_reg = B;
end

reg [15:0] result_reg;
reg [15:0] odd_reg;

always @(*)
begin
    result_reg = 0;
    odd_reg = a_reg[15:8];
    
    // Iteration 1
    if (odd_reg >= b_reg)
    begin
        result_reg[8] = 1;
        odd_reg = odd_reg - b_reg;
    end
    odd_reg = {odd_reg[7:0], a_reg[7]};
    
    // Iteration 2
    if (odd_reg >= b_reg)
    begin
        result_reg[7] = 1;
        odd_reg = odd_reg - b_reg;
    end
    odd_reg = {odd_reg[7:0], a_reg[6]};
    
    // Iteration 3
    if (odd_reg >= b_reg)
    begin
        result_reg[6] = 1;
        odd_reg = odd_reg - b_reg;
    end
    odd_reg = {odd_reg[7:0], a_reg[5]};
    
    // Iteration 4
    if (odd_reg >= b_reg)
    begin
        result_reg[5] = 1;
        odd_reg = odd_reg - b_reg;
    end
    odd_reg = {odd_reg[7:0], a_reg[4]};
    
    // Iteration 5
    if (odd_reg >= b_reg)
    begin
        result_reg[4] = 1;
        odd_reg = odd_reg - b_reg;
    end
    odd_reg = {odd_reg[7:0], a_reg[3]};
    
    // Iteration 6
    if (odd_reg >= b_reg)
    begin
        result_reg[3] = 1;
        odd_reg = odd_reg - b_reg;
    end
    odd_reg = {odd_reg[7:0], a_reg[2]};
    
    // Iteration 7
    if (odd_reg >= b_reg)
    begin
        result_reg[2] = 1;
        odd_reg = odd_reg - b_reg;
    end
    odd_reg = {odd_reg[7:0], a_reg[1]};
    
    // Iteration 8
    if (odd_reg >= b_reg)
    begin
        result_reg[1] = 1;
        odd_reg = odd_reg - b_reg;
    end
    odd_reg = {odd_reg[7:0], a_reg[0]};
    
    // Iteration 9
    if (odd_reg >= b_reg)
    begin
        result_reg[0] = 1;
        odd_reg = odd_reg - b_reg;
    end
    
    result = result_reg;
    odd = odd_reg;
end

endmodule