module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~a & ~b & (~c | d)) | 
             (~a & b & (d | (~c & ~d))) | 
             (a & ~b & d) | 
             (a & b & (~c | d));

endmodule