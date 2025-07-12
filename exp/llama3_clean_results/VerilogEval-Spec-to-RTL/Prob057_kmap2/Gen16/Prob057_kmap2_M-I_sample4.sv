module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Correct logic based on the Karnaugh map analysis
assign out = (~c & ~d & (~a | b | ~b)) | 
             (~c & d & ~a) | 
             (~c & d & b & ~a) | 
             (c & d & a & b) | 
             (c & d & ~a & b) | 
             (~c & ~d & a & ~b) | 
             (c & ~d & a & ~b) | 
             (~c & ~d & ~a & b);

endmodule