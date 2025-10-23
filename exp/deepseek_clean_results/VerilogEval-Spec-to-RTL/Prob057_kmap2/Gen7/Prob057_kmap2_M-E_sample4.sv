module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1, term2, term3, term4, term5;

assign term1 = ~c & ~d;              // First prime implicant
assign term2 = ~a & ~b;              // Second prime implicant
assign term3 = c & d & b;            // Third prime implicant
assign term4 = ~d & a & ~b;          // Fourth prime implicant
assign term5 = c & ~d & a;           // Fifth prime implicant

assign out = term1 | term2 | term3 | term4 | term5;

endmodule