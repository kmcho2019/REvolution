module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    assign out = a + (b ^ {8{do_sub}}) + do_sub;
    assign result_is_zero = (out == 8'b0);

endmodule