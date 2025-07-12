module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Optimized operand selection using mux instead of XOR
    wire [7:0] b_operand = do_sub ? ~b : b;
    
    // 9-bit adder to incorporate carry-in efficiently
    wire [8:0] sum_ext = {1'b0, a} + {1'b0, b_operand} + do_sub;
    assign out = sum_ext[7:0];

    // Fast zero detection with reduction NOR
    assign result_is_zero = ~(|out);

endmodule