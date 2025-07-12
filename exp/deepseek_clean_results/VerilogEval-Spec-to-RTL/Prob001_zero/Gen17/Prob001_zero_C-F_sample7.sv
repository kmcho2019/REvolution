module TopModule (
    output zero  // Single output port for constant LOW signal
);
    // Optimal implementation for always-LOW output:
    // - Zero-delay constant assignment
    // - No power consumption (static value)
    // - Minimal area (direct connection)
    assign zero = 1'b0;
endmodule