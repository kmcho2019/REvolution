module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    wire and_ab;
    wire and_cd;
    wire xor_and;
    
    // First layer: two AND gates
    and u_and_ab(and_ab, a, b);
    and u_and_cd(and_cd, c, d);
    
    // Intermediate layer: XOR of AND outputs
    xor u_xor(xor_and, and_ab, and_cd);
    
    // Second layer: OR gate combining one AND output and the XOR output
    or u_or(out, and_ab, xor_and);
    
    // Inverted output of out
    not u_not(out_n, out);

endmodule