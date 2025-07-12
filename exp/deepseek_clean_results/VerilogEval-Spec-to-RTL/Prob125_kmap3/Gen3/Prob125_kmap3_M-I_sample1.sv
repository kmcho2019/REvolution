module TopModule (
    input a,
    input b,
    input c,
    input d,  // d is unused as don't-cares are optimized
    output out
);
    assign out = (~c & (a ^ b)) | (c & (a | b));
endmodule