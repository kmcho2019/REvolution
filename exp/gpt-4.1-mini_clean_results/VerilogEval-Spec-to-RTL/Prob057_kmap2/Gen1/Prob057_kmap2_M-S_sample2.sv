module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Output is 1 for minterms corresponding to cells with value 1 in the K-map.
    // The K-map cells with output 1 (cd, ab): 
    // 00,00; 00,01; 00,10; 01,00; 01,10; 10,00; 10,01; 11,01; 11,10; 11,11
    //
    // Express each minterm as (!c & !d & !a & !b), etc.

    assign out = 
          (~c & ~d & ~a & ~b)  // cd=00 ab=00
        | (~c & ~d & ~a &  b)  // cd=00 ab=01
        | (~c & ~d &  a & ~b)  // cd=00 ab=10
        | (~c &  d & ~a & ~b)  // cd=01 ab=00
        | (~c &  d &  a & ~b)  // cd=01 ab=10
        | ( c & ~d & ~a & ~b)  // cd=10 ab=00
        | ( c & ~d & ~a &  b)  // cd=10 ab=01
        | ( c &  d & ~a &  b)  // cd=11 ab=01
        | ( c &  d &  a & ~b)  // cd=11 ab=10
        | ( c &  d &  a &  b); // cd=11 ab=11

endmodule