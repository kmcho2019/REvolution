module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Novel implementation using NAND-NOR logic:
       - First computes pattern detection terms
       - Then combines them using NOR logic
       - Provides alternative to XOR-based solutions
    */
    
    wire term1, term2, term3, term4;
    
    // Pattern detection terms
    nand n1(term1, ~a, ~b);
    nand n2(term2, a, b);
    nand n3(term3, ~c, ~d);
    nand n4(term4, c, d);
    
    // Final combination
    nor final_nor(out, term1 & term3, term1 & term4, 
                  term2 & term3, term2 & term4);

endmodule