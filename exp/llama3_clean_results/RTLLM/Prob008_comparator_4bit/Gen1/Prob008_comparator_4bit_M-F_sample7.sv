module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

reg A_greater_reg, A_equal_reg, A_less_reg;

always @(*)
begin
    if (A > B)
        A_greater_reg = 1'b1;
    else
        A_greater_reg = 1'b0;
        
    if (A == B)
        A_equal_reg = 1'b1;
    else
        A_equal_reg = 1'b0;
        
    if (A < B)
        A_less_reg = 1'b1;
    else
        A_less_reg = 1'b0;
end

assign A_greater = A_greater_reg;
assign A_equal = A_equal_reg;
assign A_less = A_less_reg;

endmodule