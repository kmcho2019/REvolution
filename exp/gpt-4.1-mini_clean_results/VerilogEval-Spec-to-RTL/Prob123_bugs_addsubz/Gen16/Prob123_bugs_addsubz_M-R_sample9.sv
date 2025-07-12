module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] sub_b = ~b + 8'b1;  // Two's complement of b
    wire [7:0] sub_out = a + sub_b;
    wire [7:0] add_out = a + b;

    assign out = do_sub ? sub_out : add_out;
    assign result_is_zero = (out == 8'b0);

endmodule