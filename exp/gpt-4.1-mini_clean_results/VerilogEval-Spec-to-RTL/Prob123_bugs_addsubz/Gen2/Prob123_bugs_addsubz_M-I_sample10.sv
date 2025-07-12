module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_xor = b ^ {8{do_sub}};      // Invert b if do_sub=1
    wire       carry_in = do_sub;

    assign out = a + b_xor + carry_in;       // addition or subtraction via two's complement
    assign result_is_zero = (out == 8'b0);

endmodule