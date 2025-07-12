module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Shared inverted signals
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// The output implements the Karnaugh map logic as a single expression:
// For cd=00 (nc & nd): out = ~a | ~b
// For cd=01 (nc & d):  out = ~b
// For cd=10 (c & nd):  out = ~a
// For cd=11 (c & d):   out = a | b

assign out = 
    (nc & nd) ? (na | nb) :
    (nc &  d) ? nb :
    ( c & nd) ? na :
                (a | b);

endmodule