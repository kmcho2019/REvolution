module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d & a) | (c & (a | b));

endmodule