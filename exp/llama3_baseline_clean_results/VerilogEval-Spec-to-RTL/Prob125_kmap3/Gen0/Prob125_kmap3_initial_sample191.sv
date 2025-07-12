module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (~c & (a | ~b)) | (c & (~a & ~b) | a);

endmodule