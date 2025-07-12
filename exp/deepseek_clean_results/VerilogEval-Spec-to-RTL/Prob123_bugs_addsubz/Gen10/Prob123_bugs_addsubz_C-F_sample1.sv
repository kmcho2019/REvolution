module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] operand = do_sub ? ~b + 1'b1 : b;  // Efficient 2's complement when subtracting
    assign out = a + operand;                     // Single adder operation
    assign result_is_zero = ~|out;                // Hardware-efficient zero detection

endmodule