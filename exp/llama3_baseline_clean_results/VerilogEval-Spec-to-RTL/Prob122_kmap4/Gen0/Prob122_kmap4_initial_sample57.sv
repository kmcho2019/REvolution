module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = ((~c & ~d & b & ~a) | 
             (c & ~d & (~a & ~b | ~a & b)) | 
             (~c & d & (~a & ~b | ~a & b)) | 
             (~c & ~d & (~a & ~b | ~a & b)));

endmodule