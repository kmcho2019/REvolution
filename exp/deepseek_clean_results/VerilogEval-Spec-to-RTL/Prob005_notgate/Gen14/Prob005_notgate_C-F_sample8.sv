module TopModule (
    input in,
    output out
);
    // Optimal direct NOT gate implementation
    assign out = ~in;
    
    /* Design Philosophy:
     * 1. For basic gates, direct implementation is always preferred for PPA
     * 2. This maps directly to a single inverter in ASIC or LUT1 in FPGA
     * 3. For educational purposes, this is equivalent to a LUT with config=2'b01
     * 
     * Future Extension Example:
     * reg [1:0] lut = 2'b01; // NOT configuration
     * assign out = lut[in];
     */
endmodule