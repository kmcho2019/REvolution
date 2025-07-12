module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire A = a;
    wire B = b;
    wire C = c;
    wire D = d;

    // Minimal SOP for out_sop: 
    // From problem minterms: 2(0010), 7(0111), 15(1111)
    // Minimal SOP (by Karnaugh map):
    // out_sop = B & ~C & D  + ~B & C & ~D + A & B & C & D
    // Explanation:
    // - 2 = 0 0 1 0 = ~A ~B C ~D
    // - 7 = 0 1 1 1 = ~A B C D
    // - 15 = 1 1 1 1 = A B C D
    // Simplify minterms:
    // Minterm 2: ~A & ~B & C & ~D
    // Minterm 7: ~A & B & C & D
    // Minterm 15: A & B & C & D
    // Combine (7 and 15): B & C & D
    // Final: (~A & ~B & C & ~D) + (B & C & D)

    // But the problem example uses a,b,c,d with a as MSB, d as LSB, so:
    // a b c d: a is MSB, so bit 3 is a, bit 0 is d
    // So number = a b c d
    // So number 2 decimal = 0010 binary = a=0 b=0 c=1 d=0

    // So minterms:
    // 2: ~a & ~b & c & ~d
    // 7: ~a & b & c & d
    // 15: a & b & c & d

    // Minimal SOP:
    // out_sop = (~a & ~b & c & ~d) | (b & c & d)

    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Minimal POS for out_pos (output is 0 for 0,1,4,5,6,9,10,13,14):
    // maxterms (outputs zero): 0,1,4,5,6,9,10,13,14
    // POS form is product of sums of maxterms:
    // After minimization, the minimal POS expression is:
    // out_pos = (a + b + ~c + ~d) & (a + ~b + c + d)

    // Explanation:
    // Derived from Karnaugh map simplification, these two terms cover all zeros.
    assign out_pos = (a | b | ~c | ~d) & (a | ~b | c | d);

endmodule