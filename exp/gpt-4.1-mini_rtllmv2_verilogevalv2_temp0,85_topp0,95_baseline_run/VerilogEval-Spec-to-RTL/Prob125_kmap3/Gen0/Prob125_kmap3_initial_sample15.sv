module TopModule(
    input a,
    input b,
    input c,
    input d,    // don't-care input, can be ignored for logic
    output out
);
    // Given K-map (rows=c d, columns=ab):
    //       ab
    // cd  01 00 10 11
    // 00 |d| 0| 1| 1|
    // 01 |0| 0| d| d|
    // 11 |0| 1| 1| 1|
    // 10 |0| 1| 1| 1|

    // Let's rewrite the K-map for all combinations of ab and cd:
    // c d | a b | out
    //  0 0 | 0 1 | d (choose 0)
    //  0 0 | 0 0 | 0
    //  0 0 | 1 0 | 1
    //  0 0 | 1 1 | 1
    //  0 1 | 0 1 | 0
    //  0 1 | 0 0 | 0
    //  0 1 | 1 0 | d (choose 0)
    //  0 1 | 1 1 | d (choose 0)
    //  1 1 | 0 1 | 0
    //  1 1 | 0 0 | 1
    //  1 1 | 1 0 | 1
    //  1 1 | 1 1 | 1
    //  1 0 | 0 1 | 0
    //  1 0 | 0 0 | 1
    //  1 0 | 1 0 | 1
    //  1 0 | 1 1 | 1

    // Express the truth table as out for each input combination (a,b,c,d):
    // Since d is don't care, ignore it in logic.

    // From the table, the minterms for out=1 are:
    // c d a b
    // 0 0 1 0 => c=0,d=0,a=1,b=0
    // 0 0 1 1
    // 1 1 0 0
    // 1 1 1 0
    // 1 1 1 1
    // 1 0 0 0
    // 1 0 1 0
    // 1 0 1 1

    // From the above, we can deduce the logic:

    // Let's analyze the pattern:
    // When c=0 and d=0, out=1 when a=1 and b=0 or b=1 (a=1, b=0 or 1)
    // So for c=0,d=0, out = a
    // When c=1,d=1:
    // out=1 for (a,b) = (0,0), (1,0), (1,1)
    // out=0 for (0,1)
    // So for c=1,d=1, out = ~b + a (since out=1 except when b=1,a=0)
    // When c=1,d=0:
    // out=1 when (a,b) = (0,0),(1,0),(1,1)
    // out=0 when (0,1)
    // same as above => out=~b + a
    // When c=0,d=1:
    // out=0 for all except don't cares, choose out=0 here

    // So final expression:
    // out = (~c & ~d & a) | (c & d & (~b | a)) | (c & ~d & (~b | a))

    // Simplify (c & d & X) | (c & ~d & X) = c & X where X = (~b | a)
    // So:
    // out = (~c & ~d & a) | (c & (~b | a))

    // Implement this expression in Verilog.

    assign out = (~c & ~d & a) | (c & (~b | a));

endmodule