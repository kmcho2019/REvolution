module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_mux = do_sub ? ~b : b;
    wire [7:0] sum = a + b_mux + do_sub;

    assign out = sum;
    assign result_is_zero = ~|sum;  // zero if all bits of sum are zero (bitwise NOR reduction)

endmodule