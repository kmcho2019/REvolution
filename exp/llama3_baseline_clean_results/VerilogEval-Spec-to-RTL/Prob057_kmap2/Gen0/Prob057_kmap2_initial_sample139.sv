module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Logic expression derived from the Karnaugh map
assign out = (a & ~b & ~c & ~d) | 
             (~a & b & ~c & ~d) | 
             (~a & b & c & ~d) | 
             (~a & b & d) | 
             (a & b & ~c & d) | 
             (a & ~b & c & d) | 
             (~a & ~c & d) | 
             (a & ~c & d);

endmodule