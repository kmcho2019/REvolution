module TopModule (
    output out
);
    // Optimal constant 0 driver:
    // - Minimal area (direct connection to ground)
    // - Zero timing paths (wns/tns = 0)
    // - Minimal power (only leakage current)
    assign out = 1'b0;
endmodule