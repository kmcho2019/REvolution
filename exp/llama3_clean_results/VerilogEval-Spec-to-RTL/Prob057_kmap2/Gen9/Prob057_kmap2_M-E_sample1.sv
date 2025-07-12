module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Minterm 1: (!a &&!c &&!d)
wire minterm1 = ~a & ~c & ~d;

// Minterm 2: (!a && b &&!c)
wire minterm2 = ~a & b & ~c;

// Minterm 3: (!a && b && c && d)
wire minterm3 = ~a & b & c & d;

// Minterm 4: (a && b &&!c && d)
wire minterm4 = a & b & ~c & d;

// Minterm 5: (a && b && c && d)
wire minterm5 = a & b & c & d;

// Minterm 6: (a &&!b && c &&!d)
wire minterm6 = a & ~b & c & ~d;

// Minterm 7: (!a &&!b && c && d)
wire minterm7 = ~a & ~b & c & d;

// Minterm 8: (a &&!b &&!c && d)
wire minterm8 = a & ~b & ~c & d;

// Combine minterms to produce final output
assign out = minterm1 | minterm2 | minterm3 | minterm4 | minterm5 | minterm6 | minterm7 | minterm8;

endmodule