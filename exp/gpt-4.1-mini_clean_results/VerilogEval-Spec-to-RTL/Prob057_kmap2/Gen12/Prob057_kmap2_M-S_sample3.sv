module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Complemented inputs used only as needed
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Implement simplified minimized expression:
    // out = (~c & ~b) | (c & d) | (~a & ~b & ~d) | (a & b & c)
    assign out = (nc & nb) | (c & d) | (na & nb & nd) | (a & b & c);

endmodule