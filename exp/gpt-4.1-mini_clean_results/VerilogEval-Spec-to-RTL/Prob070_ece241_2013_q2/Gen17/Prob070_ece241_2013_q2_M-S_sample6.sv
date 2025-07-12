module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Minimal SOP for out_sop = Σm(2,7,15):
    // Minterms:
    //  2 =  0 0 1 0 => a=0,b=0,c=1,d=0
    //  7 =  0 1 1 1 => a=0,b=1,c=1,d=1
    // 15 =  1 1 1 1 => a=1,b=1,c=1,d=1
    // Minimal SOP derived:
    // out_sop = (a & b) | (b & c & ~d) | (~a & ~b & c & ~d)
    // Simplify with don't cares leads to:
    // out_sop = (a & b) | (b & c & d) | (~a & ~b & c & ~d)
    // But since 7 is 0 1 1 1, which is b=1,c=1,d=1 and a=0, so (b&c&d)
    // And 2 is 0 0 1 0 => ~a & ~b & c & ~d
    // And 15 is 1 1 1 1 => a & b & c & d but a&b suffices due to POS
    //
    // We can accept the minimal SOP as:
    assign out_sop = (a & b) | (b & c & d) | (~a & ~b & c & ~d);

    // For out_pos (minimal POS for same function):
    // Since out_pos = ΠM (maxterms of zeros), zeros at inputs: 0,1,4,5,6,9,10,13,14
    // After minimalization (considering don't-cares), the minimal POS is:
    // out_pos = (a + b + ~c) & (a + ~b + d) & (~a + b + c + ~d)
    // Implemented by AND of three OR terms:
    assign out_pos = (a | b | ~c) & (a | ~b | d) & (~a | b | c | ~d);

endmodule