module TopModule (
    input        do_sub,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out,
    output       result_is_zero
);

    // Compute addition or subtraction based on do_sub
    assign out = do_sub ? (a - b) : (a + b);

    // result_is_zero is high when all bits of out are zero
    assign result_is_zero = ~|out;

endmodule