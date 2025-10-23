module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, will be ignored
    output out
);

// Define all minterms where output is 1 based on the K-map and ignoring d's don't-cares:
// Minterms (c d a b):
// For c=0,d=0: ab=10(1), 11(1) => (c & ~d & a & ~b) and (c & ~d & a & b) but c=0 here, so ~c used
wire minterm1 = (~c & ~d & a & ~b); // c=0, d=0, a=1, b=0
wire minterm2 = (~c & ~d & a & b);  // c=0, d=0, a=1, b=1

// For c=1,d=1: ab=00(1), 10(1), 11(1)
wire minterm3 = (c & d & ~a & ~b);  // c=1, d=1, a=0, b=0
wire minterm4 = (c & d & a & ~b);   // c=1, d=1, a=1, b=0
wire minterm5 = (c & d & a & b);    // c=1, d=1, a=1, b=1

// For c=1,d=0: ab=00(1),10(1),11(1)
wire minterm6 = (c & ~d & ~a & ~b); // c=1, d=0, a=0, b=0
wire minterm7 = (c & ~d & a & ~b);  // c=1, d=0, a=1, b=0
wire minterm8 = (c & ~d & a & b);   // c=1, d=0, a=1, b=1

// Sum all minterms to form output (OR of all)
assign out = minterm1 | minterm2 | minterm3 | minterm4 | minterm5 | minterm6 | minterm7 | minterm8;

endmodule