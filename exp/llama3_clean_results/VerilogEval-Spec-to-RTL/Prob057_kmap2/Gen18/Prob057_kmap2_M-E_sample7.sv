module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Minterm 1: ab'cd'
wire m1;
assign m1 = ~a & ~b & ~c & ~d;

// Minterm 2: ab'c'd
wire m2;
assign m2 = ~a & ~b & ~c & d;

// Minterm 3: ab'cd
wire m3;
assign m3 = ~a & ~b & c & d;

// Minterm 4: abc'd
wire m4;
assign m4 = ~a & b & ~c & d;

// Minterm 5: abcd'
wire m5;
assign m5 = ~a & b & c & ~d;

// Minterm 6: a'b'cd
wire m6;
assign m6 = a & ~b & c & d;

// Minterm 7: a'bc'd
wire m7;
assign m7 = a & b & ~c & ~d;

// Minterm 8: a'bc'd
wire m8;
assign m8 = a & b & ~c & d;

// Minterm 9: a'bcd
wire m9;
assign m9 = a & ~b & c & d;

// Combine minterms to get the final output
assign out = m1 | m2 | m3 | m4 | m5 | m6 | m7 | m8 | m9;

endmodule