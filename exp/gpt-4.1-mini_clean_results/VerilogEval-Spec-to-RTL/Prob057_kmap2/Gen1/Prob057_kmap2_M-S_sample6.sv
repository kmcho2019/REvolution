module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    wire term1 = nb & nd;           // b' d'
    wire term2 = nc & na;           // c' a'
    wire term3 = c & d & (a | b);  // c d (a + b)

    assign out = term1 | term2 | term3;

endmodule