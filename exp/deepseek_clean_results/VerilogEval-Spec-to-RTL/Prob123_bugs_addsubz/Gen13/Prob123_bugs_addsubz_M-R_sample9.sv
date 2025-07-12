module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Choose between addition and subtraction (two's complement)
    wire [7:0] b_operand = do_sub ? ~b + 1'b1 : b;
    
    // Perform the operation
    assign out = a + b_operand;
    
    // Zero flag is set when all bits are 0
    assign result_is_zero = (out == 8'b0);

endmodule