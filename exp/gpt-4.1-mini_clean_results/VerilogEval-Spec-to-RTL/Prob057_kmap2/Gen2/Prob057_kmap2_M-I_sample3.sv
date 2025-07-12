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

    assign out =
        (na & nc) |             // a' c'
        (nb & c & d) |          // b' c d
        (a & b & c & d) |       // a b c d
        (nb & nc & nd) |        // b' c' d'
        (a & nb & nc) |         // a b' c'
        (na & b & nd);          // a' b d'

endmodule