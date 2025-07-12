module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Optimized hybrid implementation combining best of both approaches:
       - Uses XOR operations like Example 1
       - Maintains input pair symmetry like Example 2
       - Single XOR chain for minimal delay
    */
    
    assign out = (a ^ c) ^ (b ^ d);

endmodule