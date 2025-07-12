module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_operand = do_sub ? ~b + 1'b1 : b;  // 2's complement if subtracting
    assign out = a + b_operand;
    assign result_is_zero = ~|out;  // NOR reduction for zero detection

endmodule