module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Optimal XOR-based conditional inversion and addition
    assign out = a + (b ^ {8{do_sub}}) + do_sub;
    
    // Efficient zero detection with reduction AND
    assign result_is_zero = &(~out);

endmodule