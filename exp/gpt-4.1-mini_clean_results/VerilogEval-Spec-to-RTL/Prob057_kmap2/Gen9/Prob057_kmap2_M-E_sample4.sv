module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Deriving the minimized logic from the K-map:

    // From the K-map, the ones are at minterms:
    // (cd, ab):
    // 00 00 => c=0 d=0 a=0 b=0 => m0
    // 00 01 => c=0 d=0 a=0 b=1 => m1
    // 00 10 => c=0 d=0 a=1 b=0 => m2
    // 01 00 => c=0 d=1 a=0 b=0 => m4
    // 10 00 => c=1 d=0 a=0 b=0 => m8
    // 10 01 => c=1 d=0 a=0 b=1 => m9
    // 10 10 => c=1 d=0 a=1 b=0 => m10 is 0 in K-map => no
    // 11 01 => c=1 d=1 a=0 b=1 => m13
    // 11 10 => c=1 d=1 a=1 b=0 => m14
    // 11 11 => c=1 d=1 a=1 b=1 => m15
    // 01 10 => c=0 d=1 a=1 b=0 => m6 is 0 in K-map
    // 01 11 => c=0 d=1 a=1 b=1 => m7 is 0
    // 10 11 => c=1 d=0 a=1 b=1 => m11 is 0
    // 00 11 => c=0 d=0 a=1 b=1 => m3 is 0
    // 01 01 => c=0 d=1 a=0 b=1 => m5 is 0
    // 10 10 => c=1 d=0 a=1 b=0 => m10 is 0
    // 01 11 => c=0 d=1 a=1 b=1 => m7 is 0

    // After grouping and simplification, the minimal SOP can be expressed as:

    // 1) ~c & ~d & ( ~a | ~b )
    // - Because m0,m1,m4 correspond to c=0,d=0 or d=1, a=0 or b=0
    // - Specifically, the group covers (c=0,d=0), a=0 or b=0 conditions.
    // But checking closely:
    // From the K-map, the top-left corner (c=0,d=0) has 1 at ab=00,01,10
    // So (c=0 & d=0) & (~a | ~b) covers these three minterms.

    // 2) ~d & ~a
    // - Covers minterms m0 (00 00) and m8 (10 00), i.e., d=0 a=0 regardless of b,c sometimes.
    // Actually, m0 and m8 are (c=0,d=0,a=0,b=0) and (c=1,d=0,a=0,b=0)
    // So this matches ~d & ~a.

    // 3) c & d & (a | b)
    // Covers minterms m13,m14,m15 (11 01,11 10,11 11).

    // 4) ~c & b
    // Check minterms with c=0,b=1 which are 1: m1 (c=0,d=0,a=0,b=1)
    // However, at m5 (c=0,d=1,a=0,b=1) is 0, so it's not simple.

    // To maintain clarity, I will implement the simplest explicit product terms from analysis:

    // Using the provided K-map groups, I implement the function as:
    // out = (~c & ~d & ~a) | (~c & ~d & ~b) | (~d & ~a) | (c & d & a) | (c & d & b) | (~c & ~d & b) | (c & ~d & ~a) | (c & ~d & b) | (d & ~c & ~a) ...

    // But for clarity and efficiency, I will derive the simplest final SOP from the K-map:

    // The minimal expression according to K-map:
    // out = (~d & ~a) | (~c & ~b) | (c & d & (a | b)) | (~c & d & ~a) | (c & ~d & b)

    // Let's implement these five terms:

    wire term1 = ~d & ~a;
    wire term2 = ~c & ~b;
    wire term3 = c & d & (a | b);
    wire term4 = ~c & d & ~a;
    wire term5 = c & ~d & b;

    assign out = term1 | term2 | term3 | term4 | term5;

endmodule