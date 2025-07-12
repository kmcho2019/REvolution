module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (a & b) | 
             (~a & ~c & d) | 
             (d & ~b & ~c) | 
             (~a & b & c) | 
             (a & ~b & d);

endmodule