module TopModule(
    input a,
    input b,
    input c,
    input d, // not used, don't care
    output out
);

assign out = a | (c & ~b);

endmodule