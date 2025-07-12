module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Use ternary operator for adder/subtractor selection
    assign out = do_sub ? (a - b) : (a + b);
    
    // Direct comparison for zero flag
    assign result_is_zero = (out == 8'b0);

endmodule