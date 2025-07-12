module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The Karnaugh map suggests the following conditions for out to be 1:
// 1. When c and d are 00, out is 1 if a and b are not both 1.
// 2. Specific other conditions based on the map.

assign out = (~c & ~d & ~(a & b)) | 
             (~c & ~d & (a | b)) | 
             (~c & d & ~a & b) | 
             (c & ~d & ~a & b) | 
             (c & d & a & ~b) | 
             (c & d & ~a & b);

endmodule