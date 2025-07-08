module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (a & ~c & ~d) | (a & c) | (c & b & ~a);

endmodule