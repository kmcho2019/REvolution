module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the simplified Boolean expression based on Karnaugh map
assign out = ((~c & ~d) & (~a & ~b | ~a & b | a & ~b)) | 
             ((~c & d) & (~a & ~b | a & ~b)) | 
             ((c & ~d) & (~a & ~b | ~a & b)) | 
             ((c & d) & (~a & b | a & b));

endmodule