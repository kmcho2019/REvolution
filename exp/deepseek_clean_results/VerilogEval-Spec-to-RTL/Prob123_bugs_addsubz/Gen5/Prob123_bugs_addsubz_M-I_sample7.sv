module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [8:0] sum = a + (do_sub ? ~b : b) + do_sub;
    
    assign out = sum[7:0];
    assign result_is_zero = ~(|out);

endmodule