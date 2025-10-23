module TopModule(
    input a,
    input b,
    output out
);
    nor (out, a, b);
endmodule