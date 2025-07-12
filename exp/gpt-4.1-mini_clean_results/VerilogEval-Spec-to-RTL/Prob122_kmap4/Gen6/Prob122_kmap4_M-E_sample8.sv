module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire not_a, not_b, not_c, not_d;
    wire m1, m2, m3, m4, m5, m6, m7, m8;

    // Invert inputs
    assign not_a = ~a;
    assign not_b = ~b;
    assign not_c = ~c;
    assign not_d = ~d;

    // Minterms corresponding to output=1 cells in K-map
    // cd ab = 00 01 11 10
    // Rows: cd=00,01,11,10
    // Cols: ab=00,01,11,10

    // Positions with 1:
    // (cd=00,ab=01): c=0 d=0 a=0 b=1  => not_c & not_d & not_a & b
    assign m1 = not_c & not_d & not_a & b;

    // (cd=00,ab=10): c=0 d=0 a=1 b=0 => not_c & not_d & a & not_b
    assign m2 = not_c & not_d & a & not_b;

    // (cd=01,ab=00): c=0 d=1 a=0 b=0 => not_c & d & not_a & not_b
    assign m3 = not_c & d & not_a & not_b;

    // (cd=01,ab=11): c=0 d=1 a=1 b=1 => not_c & d & a & b
    assign m4 = not_c & d & a & b;

    // (cd=11,ab=01): c=1 d=1 a=0 b=1 => c & d & not_a & b
    assign m5 = c & d & not_a & b;

    // (cd=11,ab=10): c=1 d=1 a=1 b=0 => c & d & a & not_b
    assign m6 = c & d & a & not_b;

    // (cd=10,ab=00): c=1 d=0 a=0 b=0 => c & not_d & not_a & not_b
    assign m7 = c & not_d & not_a & not_b;

    // (cd=10,ab=11): c=1 d=0 a=1 b=1 => c & not_d & a & b
    assign m8 = c & not_d & a & b;

    // Sum all minterms
    assign out = m1 | m2 | m3 | m4 | m5 | m6 | m7 | m8;

endmodule