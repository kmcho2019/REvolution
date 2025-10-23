module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Using the Karnaugh map to derive the correct logic expression
// The output is 1 for the following input combinations: (00, 00), (00, 01), (00, 10), (01, 00), (01, 10), (10, 11), (11, 01), (11, 10)
// These can be implemented as follows:
assign out = (~a & ~b & ~c & ~d) | 
             (~a & ~b & ~c & d) | 
             (~a & ~b & c & ~d) | 
             (~a & b & ~c & ~d) | 
             (~a & b & c & ~d) | 
             (a & ~b & c & d) | 
             (a & b & ~c & d) | 
             (a & b & c & ~d);

endmodule