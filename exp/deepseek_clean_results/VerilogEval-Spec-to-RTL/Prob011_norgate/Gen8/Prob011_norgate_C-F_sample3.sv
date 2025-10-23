module TopModule(
    input a,
    input b,
    output out
);
    // Truth table:
    // a b | out
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 0
    assign out = ~(a | b);
endmodule