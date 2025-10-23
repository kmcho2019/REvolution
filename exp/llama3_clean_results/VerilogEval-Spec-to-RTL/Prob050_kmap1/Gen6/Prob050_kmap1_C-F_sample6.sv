module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

always_comb out = a | b | c;

endmodule