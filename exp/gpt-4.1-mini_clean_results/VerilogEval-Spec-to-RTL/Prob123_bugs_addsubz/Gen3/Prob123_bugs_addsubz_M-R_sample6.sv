module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Perform addition or subtraction by conditional XOR and carry-in
    assign out = a + (b ^ {8{do_sub}}) + do_sub;

    // result_is_zero is high if all bits of out are zero
    assign result_is_zero = ~|out;

endmodule