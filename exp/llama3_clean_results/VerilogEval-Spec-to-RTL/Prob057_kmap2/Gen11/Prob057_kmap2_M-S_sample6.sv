module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~c & (a | ~a & ~d)) | 
             (b & (c | ~c & d));

endmodule