module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Parallel computation paths
    wire [7:0] add_result = a + b;
    wire [7:0] sub_result = a - b;
    
    // Output selection
    assign out = do_sub ? sub_result : add_result;
    
    // Early zero detection
    wire add_zero = (a == ~b + 1'b1);  // a == -b
    wire sub_zero = (a == b);          // a == b
    wire arithmetic_zero = (out == 8'b0);
    
    // Final zero determination
    assign result_is_zero = (do_sub ? sub_zero : add_zero) | arithmetic_zero;

endmodule