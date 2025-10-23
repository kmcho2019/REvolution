module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    // Calculate the two's complement of b if do_sub is 1
    wire [7:0] b_signed;
    assign b_signed = do_sub ? (~b + 1) : b;

    // Adder module
    assign out = a + b_signed;

    // Comparator module for zero flag
    assign result_is_zero = ~(|out); // Using reduction OR to check if any bit is set

endmodule