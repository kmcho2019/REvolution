module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = ~(
    (!a & !b & c & d) |  // cd=11, ab=00
    (a & b & !c) |       // cd=01/11, ab=11
    (a & c & !d) |       // cd=10, ab=11/10
    (!a & b & !c & d)    // cd=01, ab=01
);

endmodule