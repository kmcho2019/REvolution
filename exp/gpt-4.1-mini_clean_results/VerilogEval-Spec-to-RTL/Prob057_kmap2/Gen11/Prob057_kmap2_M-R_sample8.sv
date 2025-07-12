module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Using direct continuous assignments with conditional operators
assign out = 
    (~c & ~d & (~a | ~b)) ? 1'b1 :
    (~c &  d & ~b)        ? 1'b1 :
    ( c & ~d & ~a)        ? 1'b1 :
    ( c &  d & (a | b))   ? 1'b1 :
    1'b0;

endmodule