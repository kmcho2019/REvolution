module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Conditionally invert b for subtraction (two's complement)
    wire [7:0] b_inverted = b ^ {8{do_sub}};

    // Perform addition with carry_in = do_sub for subtraction
    wire [8:0] sum_ext = {1'b0, a} + {1'b0, b_inverted} + do_sub;

    // Assign outputs combinationally
    assign out = sum_ext[7:0];
    assign result_is_zero = ~|out;  // Reduction NOR to detect zero

endmodule