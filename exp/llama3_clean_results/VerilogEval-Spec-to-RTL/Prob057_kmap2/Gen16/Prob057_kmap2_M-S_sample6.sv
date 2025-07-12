module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~c & ~d & (~a | b | ~b & a)) | 
             (~c & d & (~a | ~b & a)) | 
             (c & ~d & (~a & ~b)) | 
             (c & d & (b | ~a & b)) | 
             (~c & ~d & b & ~a) | 
             (c & d & ~a & b);

endmodule