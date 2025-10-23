module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Boolean expression derived from K-map
// out = 1 unless any of these conditions are true:
assign out = !(
    (!a & !b & c & d) |      // cd=11, ab=00
    (!a & b & !c & d) |      // cd=01, ab=01
    (a & b & !c & d) |       // cd=01, ab=11
    (a & b & c & !d) |       // cd=10, ab=11
    (a & !b & c & !d) |      // cd=10, ab=10
    (a & b & !c & !d)        // cd=00, ab=11
);

endmodule