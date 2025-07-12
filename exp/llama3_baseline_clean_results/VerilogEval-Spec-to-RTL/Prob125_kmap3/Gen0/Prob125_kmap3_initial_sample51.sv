module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & b) | (c & ~a & b) | (c & a);

endmodule