module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Minimal SOP for out_sop (1 at 2,7,15):
    // Minterms for 2 (0010), 7(0111), 15(1111)
    // Variables: a b c d
    // Sum of minterms: m2 + m7 + m15
    // From K-map minimization:
    // out_sop = (a & b & c & d) | (~a & b & c & d) | (~a & ~b & c & ~d)
    // Simplified further:
    // out_sop = c & d & (a | b) | (~a & ~b & c & ~d)

    wire term1, term2, term3;
    assign term1 = a & b & c & d;           // m15
    assign term2 = (~a) & b & c & d;        // m7
    assign term3 = (~a) & (~b) & c & (~d);  // m2
    assign out_sop = term1 | term2 | term3;

    // Minimal POS for out_pos (1 for all except zeros):
    // Zeros at: 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
    // Maxterms correspond to zeros:
    // out_pos = (a + b + c + d)(a + b + c + ~d)(a + ~b + c + d)(a + ~b + c + ~d)(a + ~b + ~c + d)
    //           (~a + b + c + ~d)(~a + b + ~c + d)(~a + ~b + c + d)(~a + ~b + c + ~d)
    // After simplification (grouping):
    // out_pos = (a + c) & (b + c + d) & (b + c + ~d) & (b + ~c + ~d)

    // But since the problem is specific, let's do direct minimal POS from the zeros:
    // Alternatively, use the complements of SOP for zeros:
    // Let's use minimal POS derived from zeros' maxterms:
    // out_pos = (a + b + c + d) & (a + b + c + ~d) & (a + ~b + c + d) & (a + ~b + c + ~d) &
    //           (~a + b + c + ~d) & (~a + b + ~c + d) & (~a + ~b + c + d) & (~a + ~b + c + ~d)

    assign out_pos = (a | b | c | d) & 
                     (a | b | c | ~d) & 
                     (a | ~b | c | d) & 
                     (a | ~b | c | ~d) & 
                     (~a | b | c | ~d) & 
                     (~a | b | ~c | d) & 
                     (~a | ~b | c | d) & 
                     (~a | ~b | c | ~d);

endmodule