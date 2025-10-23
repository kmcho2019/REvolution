module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~c & d & b) | 
             (a & ~b & ~c & d) | 
             (a & b & c & ~d) | 
             (a & ~b & c & ~d);

endmodule