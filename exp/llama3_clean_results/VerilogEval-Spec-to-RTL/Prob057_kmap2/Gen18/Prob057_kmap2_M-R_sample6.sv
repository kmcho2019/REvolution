module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implement the logic using basic gates
assign out = (a & ~c & (b | ~b)) | 
             (~a & b & c) | 
             (~a & ~b & ~d & (c | ~c)) | 
             (d & ~c & (a | ~a) & b);

endmodule