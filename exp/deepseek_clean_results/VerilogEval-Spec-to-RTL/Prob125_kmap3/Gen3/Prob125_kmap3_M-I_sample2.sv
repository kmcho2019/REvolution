module TopModule (
    input a,
    input b,
    input c,
    input d,  // d is unused but kept for interface compatibility
    output out
);
    assign out = (c & (a | b)) | (~c & (a ^ b));
endmodule