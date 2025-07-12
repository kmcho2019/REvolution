module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] out,
    output wire       result_is_zero
);

    wire [7:0] b_in;  // Operand B, conditionally inverted for subtraction
    wire [8:0] sum;   // Wider sum to include carry-out if needed (optional)

    // Invert B if do_sub=1 (for subtraction via two's complement)
    assign b_in = b ^ {8{do_sub}};

    // Add A + B_in + do_sub (where do_sub acts as the carry-in for subtraction)
    assign sum = {1'b0, a} + {1'b0, b_in} + do_sub;

    // Output is lower 8 bits of sum
    assign out = sum[7:0];

    // result_is_zero is 1 if all bits of out are zero
    assign result_is_zero = ~|out;

endmodule