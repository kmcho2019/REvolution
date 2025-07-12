module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Simplified expression derived from Karnaugh map grouping:
    // out = (~c & ~a) 
    //     | (~c & ~b & d)
    //     | (c & (~b | a))
    //
    // Explanation:
    // - Group1: cd=00 and ab=00,01,10 (all with ~c & ~a)
    // - Group2: cd=01 with ab=00,10 => ~c & d & ~b
    // - Group3: cd=11 and cd=10 groups merged as c & (~b | a)

    assign out = (~c & ~a) | (~c & d & ~b) | (c & (~b | a));

endmodule