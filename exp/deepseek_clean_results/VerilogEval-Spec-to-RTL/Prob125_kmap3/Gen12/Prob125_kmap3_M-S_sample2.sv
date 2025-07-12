module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Simplified logic: out = a OR (c AND NOT b)
    assign out = a | (c & ~b);
endmodule