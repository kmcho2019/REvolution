module TopModule (
    input in,
    output out
);
    // Transmission gate implementation
    wire n_enable = 1'b0;  // Always enabled (inverted for PMOS)
    wire enable = 1'b1;    // Always enabled for NMOS
    
    // Transmission gate behavior
    assign out = enable ? (n_enable ? 1'bz : in) : 1'bz;
endmodule