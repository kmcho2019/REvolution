module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_modified;
    wire [8:0] sum;

    // Conditionally invert b bits for subtraction (two's complement)
    assign b_modified = b ^ {8{do_sub}};
    // Perform addition with carry-in = do_sub
    assign sum = {1'b0, a} + {1'b0, b_modified} + do_sub;

    // Output is the lower 8 bits of sum
    assign out = sum[7:0];
    // Zero flag set if result is zero (reduction NOR)
    assign result_is_zero = ~|sum[7:0];

endmodule