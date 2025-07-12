module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    assign out = (nc & (na | nb)) | (c & d & (a | b)) | (c & nd & na);

endmodule