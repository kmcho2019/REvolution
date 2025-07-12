module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d & ~(a & b)) |  // cd=00 except ab=11
             (~c & d & (~a | ~b)) |   // cd=01 when ab=00 or 10
             (c & d & (a | b)) |      // cd=11 except ab=00
             (c & ~d & (~a | ~b));    // cd=10 when ab=00 or 01

endmodule