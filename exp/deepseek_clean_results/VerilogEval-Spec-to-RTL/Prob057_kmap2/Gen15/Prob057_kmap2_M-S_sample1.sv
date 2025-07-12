module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = ~(
    (!a & !b & c & d) |  // cd=11, ab=00
    (a & b & !c & d) |   // cd=01, ab=11
    (a & b & c & !d)     // cd=10, ab=11
);

endmodule