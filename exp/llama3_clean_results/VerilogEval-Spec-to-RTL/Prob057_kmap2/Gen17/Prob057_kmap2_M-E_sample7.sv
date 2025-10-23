module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = 
    // cd = 00, ab can be 00, 01, 10
    (~c & ~d & (~a & ~b | ~a & b | a & ~b)) |
    // cd = 01, ab can be 00, 10
    (~c & d & (~a & ~b | a & ~b)) |
    // cd = 11, ab can be 01, 11, 10
    (c & d & (~a & b | a & b | a & ~b)) |
    // cd = 10, ab can be 00, 01
    (c & ~d & (~a & ~b | ~a & b));

endmodule