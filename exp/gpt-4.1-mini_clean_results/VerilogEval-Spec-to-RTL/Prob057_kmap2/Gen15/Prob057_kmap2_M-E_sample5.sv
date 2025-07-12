module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire out_cd00, out_cd01, out_cd11, out_cd10;

    // cd=00 (c=0, d=0): output 1 except when a=1 and b=1 (from K-map: 1 1 0 1)
    assign out_cd00 = ~(a & b);

    // cd=01 (c=0, d=1): output 1 when (a=0,b=0) or (a=1,b=0) or (a=1,b=1) from map: 1 0 0 1
    // Pattern: ab=00->1, 01->0, 11->0, 10->1
    // Simplified expression: (~a & ~b) | (a & ~b)
    assign out_cd01 = ~b;

    // cd=11 (c=1, d=1): output 1 for ab=01,11,10; 0 for 00 (0 1 1 1)
    // Simplify: b | (a & ~b)
    assign out_cd11 = b | (a & ~b);

    // cd=10 (c=1, d=0): output 1 for ab=00,01; 0 for 10,11 (1 1 0 0)
    // Simplify: ~a
    assign out_cd10 = ~a;

    // Select output based on c and d
    assign out = ( ~c & ~d & out_cd00 ) |
                 ( ~c &  d & out_cd01 ) |
                 (  c &  d & out_cd11 ) |
                 (  c & ~d & out_cd10 );

endmodule