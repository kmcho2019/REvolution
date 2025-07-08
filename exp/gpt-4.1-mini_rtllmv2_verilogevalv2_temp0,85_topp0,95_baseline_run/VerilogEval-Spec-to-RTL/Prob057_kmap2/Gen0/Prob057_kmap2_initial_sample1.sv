module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // From the Karnaugh map:
    // cd\ab  00  01  11  10
    // 00     1   1   0   1
    // 01     1   0   0   1
    // 11     0   1   1   1
    // 10     1   1   0   0
    //
    // Inputs as bits: a,b,c,d
    // We'll use ab as two bits (a is MSB), cd as two bits (c is MSB)
    // Let's list all 16 input combinations and mark output=1:
    //
    // a b c d | out
    // 0 0 0 0 | 1 (cd=00, ab=00)
    // 0 1 0 0 | 1 (cd=00, ab=01)
    // 1 0 0 0 | 1 (cd=00, ab=10)
    // 0 0 0 1 | 1 (cd=01, ab=00)
    // 1 0 0 1 | 1 (cd=01, ab=10)
    // 0 1 1 1 | 1 (cd=11, ab=01)
    // 1 1 1 1 | 1 (cd=11, ab=11)
    // 1 0 1 1 | 1 (cd=11, ab=10)
    // 0 0 1 0 | 1 (cd=10, ab=00)
    // 0 1 1 0 | 1 (cd=10, ab=01)
    //
    // Also 1 1 0 0 = 0; 1 1 0 1=0; etc.
    //
    // Writing all minterms where output=1:
    //
    // m0 = ~a & ~b & ~c & ~d
    // m1 = ~a & b & ~c & ~d
    // m2 = a & ~b & ~c & ~d
    // m4 = ~a & ~b & c & ~d
    // m6 = a & ~b & c & ~d
    // m9 = ~a & b & c & d
    // m11= a & b & c & d
    // m10= a & b & c & ~d
    // m8 = ~a & ~b & c & d
    // m9 = ~a & b & c & d (already above)
    //
    // Let's express out as sum of these minterms:
    // out = m0 + m1 + m2 + m4 + m6 + m8 + m9 + m10 + m11
    //
    // For a simpler expression, we can derive directly or implement as a logic OR of all minterms.
    //
    // Implementation: use the above minterms ORed.
    wire m0 = ~a & ~b & ~c & ~d;
    wire m1 = ~a & b & ~c & ~d;
    wire m2 = a & ~b & ~c & ~d;
    wire m4 = ~a & ~b & c & ~d;
    wire m6 = a & ~b & c & ~d;
    wire m8 = ~a & ~b & c & d;
    wire m9 = ~a & b & c & d;
    wire m10= a & b & c & ~d;
    wire m11= a & b & c & d;

    assign out = m0 | m1 | m2 | m4 | m6 | m8 | m9 | m10 | m11;

endmodule