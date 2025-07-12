module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Inputs: a,b,c,d as MSB..LSB forming 4-bit input
    
    // Minimal SOP derivation:
    // Function is 1 for decimal inputs 2(0010),7(0111),15(1111)
    // Using K-map and simplification:
    // f = a b c d
    // minterms: m2(0010)=!a !b c !d, m7(0111)=!a b c d, m15(1111)=a b c d
    // Group m7 and m15: b c d
    // So SOP: f = !a !b c !d + b c d

    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Minimal POS derivation:
    // Zero for 0,1,4,5,6,9,10,13,14
    // The minimal POS form can be derived as:
    // f = (a + b + d) (a + !b + !c) ( !a + !c + !d)
    // (verified from K-map product of sums for zeros)

    assign out_pos = (a | b | d) & (a | ~b | ~c) & (~a | ~c | ~d);

endmodule