module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // For subtraction: invert b and add 1 (do_sub) to perform two's complement
    wire [7:0] b_mod = b ^ {8{do_sub}};
    wire [8:0] sum_ext = {1'b0, a} + {1'b0, b_mod} + do_sub;

    assign out = sum_ext[7:0];
    assign result_is_zero = ~|sum_ext[7:0];

endmodule