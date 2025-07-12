module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_operand;
    wire [8:0] sum;

    // If do_sub is 1, invert b for two's complement subtraction
    assign b_operand = do_sub ? ~b : b;
    // Add a + b_operand + do_sub (carry_in)
    assign sum = {1'b0, a} + {1'b0, b_operand} + do_sub;

    // Output is the lower 8 bits of sum
    assign out = sum[7:0];
    // result_is_zero is high when out is zero
    assign result_is_zero = (out == 8'b0);

endmodule