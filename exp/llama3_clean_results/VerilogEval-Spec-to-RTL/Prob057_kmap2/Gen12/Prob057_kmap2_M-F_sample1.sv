module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~c & ~d) | 
             (~a & b & ~c) | 
             (~a & b & d) | 
             (a & b & ~c) | 
             (~a & ~b & d) | 
             (a & ~b & d) | 
             (a & b & c & d) | 
             (a & ~b & c & d);

endmodule