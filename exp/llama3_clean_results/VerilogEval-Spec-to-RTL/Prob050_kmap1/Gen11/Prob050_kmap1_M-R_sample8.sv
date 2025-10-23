module TopModule(
    input a,
    input b,
    input c,
    output out
);

assign out = a | (~a & (b | c));

endmodule