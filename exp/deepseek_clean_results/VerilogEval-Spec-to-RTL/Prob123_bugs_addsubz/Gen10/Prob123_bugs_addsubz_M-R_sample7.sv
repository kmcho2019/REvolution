module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Select between b and its complement based on do_sub
    wire [7:0] operand_b = do_sub ? ~b : b;
    
    // Perform addition (a + b) or subtraction (a + ~b + 1)
    wire [7:0] sum = a + operand_b + do_sub;
    
    // Output the result
    assign out = sum;
    
    // Zero flag is set when all bits of out are 0
    assign result_is_zero = (out == 8'b0);

endmodule