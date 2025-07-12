module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire m0, m1, m2, m4, m6, m8, m9, m13, m14, m15;

    assign m0  = (~c) & (~d) & (~a) & (~b);
    assign m1  = (~c) & (~d) & (~a) & b;
    assign m2  = (~c) & (~d) & a & (~b);
    assign m4  = (~c) & d & (~a) & (~b);
    assign m6  = (~c) & d & a & (~b);
    assign m8  = c & (~d) & (~a) & (~b);
    assign m9  = c & (~d) & (~a) & b;
    assign m13 = c & d & (~a) & b;
    assign m14 = c & d & a & (~b);
    assign m15 = c & d & a & b;

    assign out = m0 | m1 | m2 | m4 | m6 | m8 | m9 | m13 | m14 | m15;

endmodule