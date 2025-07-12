module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Even parity: q=1 if number of ones in {a,b,c,d} is 0,2 or 4
    // Sum of minterms with even number of ones:
    // 0000 (0 ones), 0011 (2 ones), 0101 (2 ones), 0110 (2 ones),
    // 1001 (2 ones), 1010 (2 ones), 1100 (2 ones), 1111 (4 ones)
    assign q =
        (~a & ~b & ~c & ~d) |
        (~a & ~b &  c &  d) |
        (~a &  b & ~c &  d) |
        (~a &  b &  c & ~d) |
        ( a & ~b & ~c &  d) |
        ( a & ~b &  c & ~d) |
        ( a &  b & ~c & ~d) |
        ( a &  b &  c &  d);

endmodule