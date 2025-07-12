module TopModule(
    input a,
    input b,
    output out
);
    // NOR gate truth table:
    // a b | out
    // --------
    // 0 0 | 1
    // 0 1 | 0
    // 1 0 | 0
    // 1 1 | 0
    assign out = ~(a | b);  // Optimal direct implementation
endmodule