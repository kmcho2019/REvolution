module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (c & b) | (a & ~c & ~d);

endmodule