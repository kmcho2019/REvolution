module TopModule(
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    // Optimal NOR gate implementation with:
    // - Single gate delay (best timing)
    // - Minimal power consumption
    // - Smallest possible area
    assign out = ~(a | b);
endmodule