module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~c & ~d) | 
             (~a & ~c & b) | 
             (~a & c & b) | 
             (~a & c & ~b & d) | 
             (a & ~c & ~b & d) | 
             (a & ~c & b & ~d) | 
             (a & c & b & d);

endmodule