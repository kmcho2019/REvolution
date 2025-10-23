module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Conditional inversion of b bits using XOR for subtraction
    wire [7:0] b_mod = b ^ {8{do_sub}};
    
    // Sum with carry_in = do_sub to perform add or subtract
    wire [8:0] sum_ext = {1'b0, a} + {1'b0, b_mod} + do_sub;
    
    // Output is the lower 8 bits of the sum
    assign out = sum_ext[7:0];

    // result_is_zero is asserted when all bits of out are zero
    assign result_is_zero = ~|out;

endmodule