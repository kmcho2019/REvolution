module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Conditional inversion for subtraction
    wire [7:0] b_operand = do_sub ? ~b : b;
    // Addition with carry-in for subtraction
    wire [7:0] sum = a + b_operand + do_sub;

    assign out = sum;
    assign result_is_zero = (sum == 8'b0);  // Correct zero detection

endmodule