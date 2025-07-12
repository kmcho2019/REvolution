module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (b == 1) || ((~a) && (~c));

endmodule