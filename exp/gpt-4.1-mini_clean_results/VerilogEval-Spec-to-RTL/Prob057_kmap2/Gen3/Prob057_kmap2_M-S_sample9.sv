module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Minimal expression derived from the Karnaugh map:
    // out = (~c & ~d) | (~a & ~b) | (b & d) | (a & c) | (a & ~b & ~c & d)
    // Simplify as much as possible:
    // By inspection, minimal form can be:
    // out = (~c & ~d) | (~a & ~b) | (b & d) | (a & c)
    // The last term (a & ~b & ~c & d) is covered by (a & c) or (b & d) ?
    // Checking if (a & ~b & ~c & d) is already covered:
    // When a=1,b=0,c=0,d=1:
    // (a & c) = 1 & 0 = 0
    // (b & d) = 0 & 1 = 0
    // (~a & ~b) = 0 & 1 = 0
    // (~c & ~d) = 1 & 0 = 0
    // Not covered, so add the term.
    //
    // Final expression:
    assign out = (~c & ~d) | (~a & ~b) | (b & d) | (a & c) | (a & ~b & ~c & d);

endmodule