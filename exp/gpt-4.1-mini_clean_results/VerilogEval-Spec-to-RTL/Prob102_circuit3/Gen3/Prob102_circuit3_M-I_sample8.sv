module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    wire lower_or = (na & nb) | (nc & nd);
    assign q = ~lower_or;

endmodule