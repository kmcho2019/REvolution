module TopModule (
    input in,
    output out
);
    // Transmission gate implementation
    wire enable = 1'b1;  // Always enabled
    assign out = (enable & in) | (~enable & 1'bz);
endmodule