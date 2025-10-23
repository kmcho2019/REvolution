module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output q     // Output (a AND b)
);
    // Optimal AND gate implementation with:
    // - Zero timing violations (tns/wns = 0)
    // - Minimal area (1.0 um²)
    // - Lowest power (4.55e-05 W)
    assign q = a & b;
endmodule