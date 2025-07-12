module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Adder-subtractor using ternary operator
    assign out = do_sub ? (a - b) : (a + b);
    
    // Zero flag using reduction NOR (all bits zero)
    assign result_is_zero = ~(|out);

endmodule