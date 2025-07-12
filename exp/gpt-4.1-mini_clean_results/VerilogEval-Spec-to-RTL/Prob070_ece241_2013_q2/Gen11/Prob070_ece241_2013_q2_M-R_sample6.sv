module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Inputs: a=MSB, d=LSB
    // Define minterms for out_sop = 1 at inputs 2 (0010), 7 (0111), 15 (1111)

    // Binary:
    // 2  = 0 0 1 0  -> a=0,b=0,c=1,d=0
    // 7  = 0 1 1 1  -> a=0,b=1,c=1,d=1
    // 15 = 1 1 1 1  -> a=1,b=1,c=1,d=1

    // Minimal SOP for out_sop:
    // Minterms:
    // m2: ~a & ~b & c & ~d
    // m7: ~a & b & c & d
    // m15: a & b & c & d

    // Group m7 and m15:
    // b c d common, a=0 or 1 -> b & c & d
    // So SOP = (~a & ~b & c & ~d) + (b & c & d)

    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // For out_pos:
    // Output 0 at minterms 2,7,15 => Output 1 at maxterms of those minterms among known 0 cases
    // Logic function is the complement of out_sop:
    // Minimal POS is derived as product of maxterms for 0s:
    // The 0 outputs occur at 0,1,4,5,6,9,10,13,14
    // From these maxterms, minimal POS is:

    // From K-map and minimization:
    // POS = (a + b + ~c + d) & (a + ~b + c + d)

    assign out_pos = (a | b | ~c | d) & (a | ~b | c | d);

endmodule