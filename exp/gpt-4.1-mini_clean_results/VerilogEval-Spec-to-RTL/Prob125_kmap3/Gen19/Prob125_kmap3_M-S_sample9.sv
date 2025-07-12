module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care
    output out
);

assign out = (~c & a) | (c & ~b) | (c & a);

endmodule