module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The conditions under which out is 1
assign out = (~c & ~d & ~a & b) | 
             (~c & ~d & a & ~b) | 
             (~c & d & ~a & ~b) | 
             (~c & d & a & b) | 
             (c & ~d & ~a & ~b) | 
             (c & ~d & a & b) | 
             (c & d & ~a & b) | 
             (c & d & a & ~b);

endmodule