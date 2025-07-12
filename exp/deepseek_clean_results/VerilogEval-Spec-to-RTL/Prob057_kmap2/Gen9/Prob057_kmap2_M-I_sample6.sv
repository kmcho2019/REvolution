module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression with fewer terms
assign out = !(
    (a & b & (!c | !d)) |  // Combines ab=11 cases
    (!a & !b & c & d) |   // cd=11, ab=00
    (!a & b & !c & d) |   // cd=01, ab=01
    (a & !b & c & !d)     // cd=10, ab=10
);

endmodule