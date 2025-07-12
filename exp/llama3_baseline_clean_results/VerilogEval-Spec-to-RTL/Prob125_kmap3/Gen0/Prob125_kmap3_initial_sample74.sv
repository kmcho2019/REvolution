module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = b || (c == 0 && a == 1);

endmodule