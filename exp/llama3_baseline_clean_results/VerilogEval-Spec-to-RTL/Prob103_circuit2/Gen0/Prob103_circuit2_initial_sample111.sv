module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (~a & ~c & ~b) | (~a & ~c & ~d) | (~a & c & b & d) | 
           (a & ~c & ~b & d) | (a & ~c & b & ~d) | (a & c & ~b & ~d) | 
           (a & c & b & d);

endmodule