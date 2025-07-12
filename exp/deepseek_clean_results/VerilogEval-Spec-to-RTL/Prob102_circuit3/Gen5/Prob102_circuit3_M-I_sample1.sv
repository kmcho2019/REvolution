module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal implementation using minimal gates (2 ORs + 1 AND)
    // For technology-specific optimizations, consider:
    // - Using AO22 cell if available in target library
    // - Gate sizing based on input signal probabilities
    assign q = (a | b) & (c | d);
endmodule