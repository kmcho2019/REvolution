module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = ((~c & ~d) & (b & ~a | ~b & a)) | 
             ((~c & d) & (~b & ~a | b & a)) | 
             ((c & d) & (b & ~a | ~b & a)) | 
             ((c & ~d) & (~b & ~a | b & a));

endmodule