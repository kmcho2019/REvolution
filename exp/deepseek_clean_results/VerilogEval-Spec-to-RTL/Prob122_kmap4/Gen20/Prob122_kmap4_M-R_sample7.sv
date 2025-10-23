module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Refactored implementation using Boolean identity:
       Original: sel ? ~b_xor_d : b_xor_d
       Where sel = a^c and b_xor_d = b^d
       This is equivalent to (a^c) ^ (b^d)
    */
    
    assign out = (a ^ c) ^ (b ^ d);

endmodule