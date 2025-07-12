module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~c) | 
             (b & ~c) | 
             (~a & d) | 
             (a & b & d) | 
             (~b & c & d);

endmodule