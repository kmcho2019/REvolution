module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implement the simplified expression from the Karnaugh map
assign out = (a & b & ~c & ~d) | 
             (a & ~b & c & ~d) | 
             (~a & b & c & ~d) | 
             (~a & ~b & c & d) | 
             (a & ~b & ~c & d) | 
             (~a & b & ~c & d) | 
             (~a & ~b & ~c & d);

endmodule