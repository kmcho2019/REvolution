module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Optimized subtract/adder path
    wire [7:0] b_operand = do_sub ? ~b : b;
    wire [7:0] sum = a + b_operand + do_sub;
    
    // Output assignment
    assign out = sum;
    
    // Area-efficient zero detection using reduction NOR
    assign result_is_zero = ~(|sum);

endmodule