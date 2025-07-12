module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Complement inputs for reuse
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Implement simplified expression directly
    assign out = (nc & nd & (na | b)) | (nc & d & nb) | (c & nd & na) | (c & d & (a | b));

endmodule