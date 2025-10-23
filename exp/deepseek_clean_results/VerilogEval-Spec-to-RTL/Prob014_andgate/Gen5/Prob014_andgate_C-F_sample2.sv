module TopModule(
    input a,
    input b,
    output out
);
    // Optimal implementation of 2-input AND gate:
    // - Minimal timing (single gate delay)
    // - Lowest possible power for this function
    // - Minimal area (single standard cell)
    assign out = a & b;
endmodule