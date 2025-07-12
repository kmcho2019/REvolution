module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Efficient two's complement conversion for subtraction
    wire [7:0] b_operand = b ^ {8{do_sub}};
    
    // Single adder operation with carry-in for subtraction
    assign out = a + b_operand + do_sub;
    
    // Correct zero flag implementation
    assign result_is_zero = (out == 8'd0);

endmodule