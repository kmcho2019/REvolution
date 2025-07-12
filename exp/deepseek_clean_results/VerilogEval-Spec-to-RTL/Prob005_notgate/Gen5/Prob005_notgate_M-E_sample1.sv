module TopModule (
    input in,
    output out
);
    // Transmission gate style NOT implementation
    wire enable = 1'b1;  // Always enabled
    
    // NMOS behavior: pulls down when input is high
    wire nmos_out = enable & in ? 1'b0 : 1'bz;
    
    // PMOS behavior: pulls up when input is low
    wire pmos_out = enable & ~in ? 1'b1 : 1'bz;
    
    // Combine the outputs
    assign out = nmos_out | pmos_out;
endmodule