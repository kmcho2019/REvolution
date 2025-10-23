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

    wire term1 = nc & (nb | d);
    wire term2 = na & nd;
    wire term3 = c & d & (a | b);

    assign out = term1 | term2 | term3;

endmodule