module TopModule #(
    parameter WIDTH = 8
)(
    input  wire                  do_sub,
    input  wire [WIDTH-1:0]      a,
    input  wire [WIDTH-1:0]      b,
    output wire [WIDTH-1:0]      out,
    output wire                  result_is_zero
);

    wire [WIDTH-1:0] b_xor = b ^ {WIDTH{do_sub}}; // invert b if do_sub=1

    // Use built-in addition operator with carry-in as do_sub
    assign out = a + b_xor + do_sub;

    // Zero flag using reduction NOR on output
    assign result_is_zero = ~|out;

endmodule