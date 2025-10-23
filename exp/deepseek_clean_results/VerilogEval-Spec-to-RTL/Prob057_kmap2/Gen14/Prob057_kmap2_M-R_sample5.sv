module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Direct implementation of K-map groupings where output is 0
// Using De Morgan's to optimize the expression
assign out = ~(
    // cd=11 cases
    (c & d & ~a & ~b) | 
    // cd=01 cases
    (~c & d & (~a & b | a & b)) | 
    // cd=10 cases
    (c & ~d & (a & b | a & ~b)) | 
    // cd=00 case
    (~c & ~d & a & b)
);

endmodule