module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, unused
    output out
);

assign out = (~c & a) | (c & (~b | a));

endmodule