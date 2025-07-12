module TopModule (
    output zero
);
    // Optimal constant LOW output implementation
    // - Zero timing paths (wns/tns = 0ns)
    // - Minimal power (leakage only)
    // - Minimal area (output port only)
    assign zero = 1'b0;
endmodule