module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression with factored terms
assign out = !(
    (a & b & (!c | d)) |      // Combines ab=11 cases
    (!a & b & !c & d) |       // ab=01 case
    (!a & !b & c & d) |       // ab=00 case
    (a & !b & c & !d)         // ab=10 case
);

endmodule