module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_sel = do_sub ? ~b : b;
    wire [7:0] sum = a ^ b_sel;
    wire [7:0] carry = (a & b_sel) << 1;
    wire [7:0] final_sum = sum + carry + do_sub;

    // Early zero detection logic
    wire all_bits_equal = &(a ~^ b);  // XNOR reduction
    wire zero_sub_case = do_sub & all_bits_equal;
    wire zero_add_case = ~do_sub & ~(|(a | b));
    wire zero_result = ~(|final_sum);

    assign out = final_sum;
    assign result_is_zero = zero_sub_case | zero_add_case | zero_result;

endmodule