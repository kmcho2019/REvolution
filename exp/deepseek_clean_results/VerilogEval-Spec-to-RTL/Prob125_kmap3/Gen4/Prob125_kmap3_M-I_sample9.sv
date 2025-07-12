module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~c & ~d & (a | b)) | (c & ~(a & ~b)) | (d & c);
endmodule