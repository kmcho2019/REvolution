module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimized logic:
    // When a=1: output 1 (from both examples)
    // When a=0: output c & (b | ~b) which simplifies to c
    // This covers all cases from the K-map while being minimal
    assign out = a ? 1'b1 : c;
endmodule