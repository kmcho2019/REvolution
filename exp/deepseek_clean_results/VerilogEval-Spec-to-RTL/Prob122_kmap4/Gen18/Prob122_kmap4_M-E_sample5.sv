module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Implementation using multiplexer selection:
       The output follows a pattern where:
       - When a==c, output is b^d
       - When a!=c, output is ~(b^d)
       This captures the checkerboard pattern in the K-map
    */
    
    wire b_xor_d = b ^ d;
    wire sel = a ^ c;
    
    assign out = sel ? ~b_xor_d : b_xor_d;

endmodule