module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    // The Karnaugh map (cd rows, ab columns) is:
    // cd\ab 01  00  10  11
    // 00    d   0   1   1
    // 01    0   0   d   d
    // 11    0   1   1   1
    // 10    0   1   1   1
    
    // Let's choose d=0 for all don't cares for simplification

    // Now the K-map with d=0:
    // cd\ab 01  00  10  11
    // 00    0   0   1   1
    // 01    0   0   0   0
    // 11    0   1   1   1
    // 10    0   1   1   1

    // Positions of 1's:
    // (00,10) => c=0,d=0,a=1,b=0
    // (00,11) => c=0,d=0,a=1,b=1
    // (11,00) => c=1,d=1,a=0,b=0
    // (11,10) => c=1,d=1,a=1,b=0
    // (11,11) => c=1,d=1,a=1,b=1
    // (10,00) => c=1,d=0,a=0,b=0
    // (10,10) => c=1,d=0,a=1,b=0
    // (10,11) => c=1,d=0,a=1,b=1

    // Grouping the 1's and simplifying yields:
    // out = a & c | b & c & d' | a & c' & b'  (where d' is negation of d)
    // A simpler approach:
    // From K-map, the function is 1 if:
    // - c=1 (third and fourth row) and a=1 or b=1
    // - or c=0, d=0, a=1 (from first row)
    // Let's write the expression as:
    // out = (c & (a | b)) | (~c & ~d & a)

    assign out = (c & (a | b)) | (~c & ~d & a);

endmodule