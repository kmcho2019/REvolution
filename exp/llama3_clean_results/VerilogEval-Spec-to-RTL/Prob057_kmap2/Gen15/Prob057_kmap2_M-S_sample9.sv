module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Simplified implementation based on re-examined Karnaugh map
assign out = (~c & ~d & ~(a & b)) | 
             (c & d & (a | b)) | 
             (~c & d & ~a) | 
             (c & ~d & b);

endmodule