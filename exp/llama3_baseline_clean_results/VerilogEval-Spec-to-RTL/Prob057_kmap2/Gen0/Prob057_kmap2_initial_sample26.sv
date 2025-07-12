module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implement the circuit based on the Karnaugh map
assign out = ((~a & ~c & ~d) | 
              (a & ~b & ~c & ~d) | 
              (a & b & ~c & d) | 
              (~a & b & c & ~d) | 
              (~a & b & c & d) | 
              (a & b & c & d) | 
              (a & ~b & c & d));

endmodule