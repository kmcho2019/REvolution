module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Direct sum-of-products expression derived from K-map groups
    assign out = 
          (~c & ~d & (~a | ~b)) 
        | (~c & d & ~b) 
        | (c & ~d & ~a) 
        | (c & d & (a | b));

endmodule