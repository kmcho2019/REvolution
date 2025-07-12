module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~c & ~b & a) | 
             (~c & b & a) | 
             (c & ~a & b) | 
             (c & a & ~b) | 
             (c & a & b);

endmodule