module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire minterm1, minterm2, minterm3, minterm4, minterm5, minterm6, minterm7;

// Implementing the minterms based on the Karnaugh map
assign minterm1 = ~a & ~b & ~c & ~d; // 0000
assign minterm2 = ~a & ~b & ~c & d;  // 0001
assign minterm3 = ~a & ~b & c & ~d;  // 0010
assign minterm4 = ~a & b & ~c & ~d;  // 0100
assign minterm5 = ~a & b & c & ~d;  // 0101
assign minterm6 = ~a & b & c & d;   // 0111
assign minterm7 = a & ~b & ~c & ~d;  // 1000

// Combining the minterms using an OR gate
assign out = minterm1 | minterm2 | minterm3 | minterm4 | minterm5 | minterm6 | minterm7;

endmodule