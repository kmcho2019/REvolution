module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Perform addition or subtraction by conditional inversion of b and adding carry-in (do_sub)
    wire [7:0] b_mod;
    wire [8:0] sum_ext;

    assign b_mod = b ^ {8{do_sub}};          // Invert b if subtraction
    assign sum_ext = {1'b0, a} + {1'b0, b_mod} + do_sub; // add carry-in for subtraction

    assign out = sum_ext[7:0];
    assign result_is_zero = ~|out;

endmodule