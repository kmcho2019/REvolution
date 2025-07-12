module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Two's complement subtraction implemented via XOR and carry-in addition
    wire [7:0] b_xor = b ^ {8{do_sub}};
    wire [8:0] sum_ext = {1'b0, a} + {1'b0, b_xor} + do_sub;

    assign out = sum_ext[7:0];
    assign result_is_zero = ~|out; // reduction NOR to detect zero

endmodule