module TopModule (
    output zero  // Constant LOW output (hardwired to ground)
);
    // This module implements a constant LOW output
    // Characteristics:
    // - Zero timing paths (combinational direct connection)
    // - Minimal area (single ground connection)
    // - Minimal power (only leakage current)
    assign zero = 1'b0;
endmodule