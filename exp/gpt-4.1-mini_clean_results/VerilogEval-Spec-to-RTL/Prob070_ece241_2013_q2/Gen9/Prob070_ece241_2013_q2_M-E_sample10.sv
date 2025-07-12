module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Input vector N = {a,b,c,d} with a MSB, d LSB

    // Minimal SOP for outputs=1 at decimal 2(0010), 7(0111), 15(1111):

    // Minterms:
    // 2: a=0 b=0 c=1 d=0  => ~a & ~b & c & ~d
    // 7: a=0 b=1 c=1 d=1  => ~a & b & c & d
    // 15:a=1 b=1 c=1 d=1  => a & b & c & d

    // Try to group minterms for simplification:
    // Group 7 and 15 differ only in a: a can be any for these two when b=1,c=1,d=1:
    // So: b & c & d
    // The other minterm is ~a & ~b & c & ~d (for 2)
    // So SOP = (b & c & d) + (~a & ~b & c & ~d)

    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Minimal POS for the same function:

    // The output is zero for decimal 0,1,4,5,6,9,10,13,14
    // Excluded inputs (3,8,11,12) never occur, so can be considered don't cares.
    // Let's list the maxterms (where output=0):

    // Output=0 inputs (in binary, a,b,c,d):
    // 0:0000, 1:0001, 4:0100, 5:0101, 6:0110,
    // 9:1001,10:1010,13:1101,14:1110

    // From K-map POS minimization, a minimal POS expression is:

    // (a + b + ~c + ~d) & (a + ~b + c + d)

    // Explanation:
    // First sum term covers zeros where a=0 and b=0 or c=0 or d=0
    // Second sum term covers zeros with a=1 and b=0 and c=1 and d=1 cases

    assign out_pos = (a | b | ~c | ~d) & (a | ~b | c | d);

endmodule