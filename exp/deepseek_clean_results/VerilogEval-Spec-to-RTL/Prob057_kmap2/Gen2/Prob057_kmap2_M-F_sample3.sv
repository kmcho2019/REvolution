module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (~c & (~a | ~b)) | (c & d & b) | (c & ~d & (~a | b));

endmodule