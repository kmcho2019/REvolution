module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;
    wire ab, ac, ad, bc, bd, cd, abd, acd, abc;
    
    assign q = (~a & ~b & ~c & ~d) |
               (~a & b & ~c & d) |
               (~a & b & c & ~d) |
               (~a & b & c & d) |
               (a & ~b & ~c & ~d) |
               (a & ~b & c & ~d) |
               (a & ~b & ~c & d) |
               (a & b & ~c & ~d) |
               (a & b & c & d);
endmodule