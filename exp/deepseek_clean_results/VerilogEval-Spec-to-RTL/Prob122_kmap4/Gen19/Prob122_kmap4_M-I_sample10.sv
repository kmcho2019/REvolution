module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Optimized implementation using single XOR operation:
       The output is simply the XOR of all inputs, which perfectly matches
       the checkerboard pattern in the K-map
    */
    
    assign out = a ^ b ^ c ^ d;

endmodule