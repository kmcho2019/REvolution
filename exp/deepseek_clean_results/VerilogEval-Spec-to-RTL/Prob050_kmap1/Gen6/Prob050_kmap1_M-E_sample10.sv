module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire a_inv, b_inv, c_inv;
    
    // Invert each input using NAND with itself
    nand(a_inv, a, a);
    nand(b_inv, b, b);
    nand(c_inv, c, c);
    
    // Combine inverted inputs with NAND
    nand(out, a_inv, b_inv, c_inv);
endmodule