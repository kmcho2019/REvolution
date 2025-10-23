module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Optimal implementation: output is 0 only when all inputs are 0
    // This is equivalent to the OR of all inputs, which is:
    // - Minimal gate count (single OR operation)
    // - Minimal propagation delay
    // - Minimal area and power consumption
    assign out = a | b | c;
endmodule