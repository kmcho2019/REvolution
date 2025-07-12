module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_operand = do_sub ? ~b : b;
    wire carry_in = do_sub;
    
    // Compute both possible results (carry0 and carry1)
    wire [7:0] sum0, sum1;
    wire carry0, carry1;
    wire zero0, zero1;
    
    // Carry=0 path
    assign {carry0, sum0} = a + b_operand + 1'b0;
    assign zero0 = ~(|sum0);
    
    // Carry=1 path
    assign {carry1, sum1} = a + b_operand + 1'b1;
    assign zero1 = ~(|sum1);
    
    // Select correct result based on actual carry_in
    assign out = carry_in ? sum1 : sum0;
    assign result_is_zero = carry_in ? zero1 : zero0;

endmodule