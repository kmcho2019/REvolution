module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] out,
    output wire       result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] sum_with_carry;

    // Conditionally invert B bits based on do_sub for subtraction
    assign b_xor = b ^ {8{do_sub}};

    // Add A, modified B, and do_sub as carry-in for subtraction (two's complement)
    assign sum_with_carry = {1'b0, a} + {1'b0, b_xor} + do_sub;

    // Output is the lower 8 bits of the sum
    assign out = sum_with_carry[7:0];

    // Zero flag is high if all bits of out are zero
    assign result_is_zero = ~|out;

endmodule