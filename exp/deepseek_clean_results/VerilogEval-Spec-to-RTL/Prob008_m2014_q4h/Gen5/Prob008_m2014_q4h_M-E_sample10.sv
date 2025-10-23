module TopModule (
    input in,
    output out
);
    // Transmission gate-like implementation with always-on enable
    wire enable = 1'b1;  // Virtual enable signal (always active)
    assign out = enable ? in : 1'bz;
endmodule