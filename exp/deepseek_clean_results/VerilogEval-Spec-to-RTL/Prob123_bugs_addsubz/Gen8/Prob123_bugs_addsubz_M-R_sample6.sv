module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Two's complement subtraction: a - b = a + ~b + 1
    assign out = do_sub ? (a + (~b) + 1'b1 : a + b;
    
    // Zero flag using reduction NOR (equivalent to out == 0)
    assign result_is_zero = ~(|out);

endmodule