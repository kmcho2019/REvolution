module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = !(
    (c & d & !(a | b)) |      // cd=11, ab=00
    (!c & d & (a ^ b)) |      // cd=01, ab=01 or 11
    (c & !d & a) |            // cd=10, ab=11 or 10
    (!c & !d & a & b)         // cd=00, ab=11
);

endmodule