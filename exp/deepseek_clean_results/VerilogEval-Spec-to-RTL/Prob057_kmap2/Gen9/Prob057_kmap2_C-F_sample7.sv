module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Boolean expression derived from K-map with optimal grouping:
// out = ~[ (cd=00 & ab=11) | (cd=01 & b=1) | (cd=10 & a=1) | (cd=11 & ab=00) ]
assign out = ~(
    (~c & ~d &  a &  b) |  // K-map cell cd=00, ab=11
    (~c &  d &       b) |  // K-map column b=1 for cd=01
    ( c & ~d &  a     ) |  // K-map column a=1 for cd=10
    ( c &  d & ~a & ~b)    // K-map cell cd=11, ab=00
);

endmodule