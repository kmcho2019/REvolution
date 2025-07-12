module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Minterms where output is 1
    wire term1 = ~a & ~b & ~c & d;
    wire term2 = ~a & b & ~c & ~d;
    wire term3 = a & ~b & ~c & d;
    wire term4 = a & b & ~c & ~d;
    wire term5 = ~a & ~b & c & ~d;
    wire term6 = ~a & b & c & d;
    wire term7 = a & ~b & c & ~d;
    wire term8 = a & b & c & d;

    assign out = term1 | term2 | term3 | term4 | term5 | term6 | term7 | term8;
endmodule