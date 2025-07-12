module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care
    output out
);

assign out = (a & ~c) | (c & (~b | a));

endmodule