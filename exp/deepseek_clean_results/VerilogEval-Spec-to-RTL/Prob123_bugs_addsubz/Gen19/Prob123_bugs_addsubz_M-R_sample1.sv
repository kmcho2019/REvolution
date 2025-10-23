module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Explicit wire declarations
    wire [7:0] b_operand;
    wire carry_in;
    
    // Conditional inversion of operand B
    assign b_operand = b ^ {8{do_sub}};
    
    // Carry-in for subtraction (2's complement)
    assign carry_in = do_sub;
    
    // Arithmetic operation
    assign out = a + b_operand + carry_in;
    
    // Zero detection
    assign result_is_zero = (out == 8'b0);

endmodule