module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~c & (~d | b)) | 
             (a & ~c & d) | 
             (a & b & (c | ~c) & d) | 
             (~a & b & c & ~d) | 
             (b & ~c & d);

endmodule