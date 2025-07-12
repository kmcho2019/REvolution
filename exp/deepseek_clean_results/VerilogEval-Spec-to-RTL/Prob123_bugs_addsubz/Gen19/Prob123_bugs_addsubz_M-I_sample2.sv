module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Power-efficient XOR-based conditional inversion and addition
    assign out = a + (b ^ {8{do_sub}}) + do_sub;
    
    // Corrected zero detection with reduction OR (more efficient than AND)
    assign result_is_zero = ~(|out);

endmodule