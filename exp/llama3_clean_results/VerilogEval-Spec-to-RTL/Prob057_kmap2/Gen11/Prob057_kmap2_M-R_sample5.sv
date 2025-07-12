module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = ((~c & ~d) | (c & d)) & ((a & ~b) | (~a & b)) | 
             ((~c & d) | (c & ~d)) & ((a & ~b) | (~a & b));

endmodule