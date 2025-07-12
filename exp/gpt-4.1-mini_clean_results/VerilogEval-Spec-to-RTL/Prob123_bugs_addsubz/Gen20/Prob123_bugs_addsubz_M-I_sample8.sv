module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Conditionally invert b for subtraction (two's complement method)
    wire [7:0] b_invert = b ^ {8{do_sub}};

    // Perform addition of a + b_invert + do_sub (carry-in)
    wire [8:0] sum_ext = {1'b0, a} + {1'b0, b_invert} + do_sub;

    assign out = sum_ext[7:0];
    assign result_is_zero = ~|sum_ext[7:0];

endmodule