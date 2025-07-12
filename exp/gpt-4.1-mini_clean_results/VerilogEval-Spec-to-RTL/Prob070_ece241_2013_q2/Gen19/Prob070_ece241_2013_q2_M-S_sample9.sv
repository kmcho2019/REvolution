module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    wire A = a, B = b, C = c, D = d;

    // Minimal SOP for out_sop (sum of minterms 2,7,15):
    // 2 = 0010 => a=0,b=0,c=1,d=0  -> ~A & ~B & C & ~D
    // 7 = 0111 => a=0,b=1,c=1,d=1  -> ~A & B & C & D
    // 15=1111 => a=1,b=1,c=1,d=1  -> A & B & C & D
    // Simplify SOP: (~A & C & (~B & ~D + B & D)) + A & B & C & D
    // Note (~B & ~D + B & D) = ~(B ^ D)
    assign out_sop = (~A & C & ~(B ^ D)) | (A & B & C & D);

    // Minimal POS for out_pos (product of maxterms where output=0):
    // Zeros at 0,1,4,5,6,9,10,13,14 correspond to maxterms:
    // Expressed as:
    // (A + B + C + D) * (A + B + C + ~D) * (A + ~B + C + D) * 
    // (A + ~B + C + ~D) * (A + ~B + ~C + D) * 
    // (~A + B + C + D) * (~A + B + C + ~D) *
    // (~A + B + ~C + ~D) * (~A + ~B + C + D)
    //
    // The minimal POS simplifies to:
    // (A + B + C + D) * (A + ~B + C + D) * (~A + B + C + D) * (A + B + C + ~D)
    //
    // We can express minimal POS as product of sums:
    assign out_pos = (A | B | C | D) & (A | ~B | C | D) & (~A | B | C | D) & (A | B | C | ~D);

endmodule