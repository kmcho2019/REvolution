module TopModule (
    input x,
    input y,
    output z
);
    // Original expression: z = (x XOR y) AND x
    wire x_xor_y = x ^ y;
    
    // Boolean simplification: (x ^ y) & x = x & ~y
    assign z = x_xor_y & x;
    
    /* Proof of equivalence:
     * x_xor_y = x ^ y = x&~y | ~x&y
     * (x ^ y) & x = (x&~y | ~x&y) & x
     *              = x&~y&x | ~x&y&x
     *              = x&~y | 0
     *              = x&~y
     */
endmodule