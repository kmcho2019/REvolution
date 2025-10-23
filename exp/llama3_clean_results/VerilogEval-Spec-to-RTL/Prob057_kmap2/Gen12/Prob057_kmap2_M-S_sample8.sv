module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~c & ~d & (a | ~a)) | 
             (~a & ~b & (c | ~d)) | 
             (b & ~d & (a | ~a)) | 
             (a & d & (b | ~b)) | 
             (~b & c & d);

endmodule