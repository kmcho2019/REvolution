module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Use XOR for conditional inversion (more efficient than mux)
    wire [7:0] b_operand = b ^ {8{do_sub}};
    
    // Adder with carry-in for subtraction
    assign out = a + b_operand + do_sub;
    
    // Zero detection using reduction OR (might be more power-efficient)
    assign result_is_zero = ~(|out);

endmodule