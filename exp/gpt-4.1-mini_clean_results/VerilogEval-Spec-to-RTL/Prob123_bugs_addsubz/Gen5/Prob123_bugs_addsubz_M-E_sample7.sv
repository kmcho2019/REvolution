module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_modified;
    wire [8:0] sum;

    // If do_sub is 1, invert b bits, else keep as is
    assign b_modified = b ^ {8{do_sub}};
    // Perform addition with carry-in = do_sub (0 for add, 1 for subtract)
    assign sum = {1'b0, a} + {1'b0, b_modified} + do_sub;

    assign out = sum[7:0];
    assign result_is_zero = (sum[7:0] == 8'd0) ? 1'b1 : 1'b0;

endmodule